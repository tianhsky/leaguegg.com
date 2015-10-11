# Services related to current game, fetch live game status from riot or cache
module GameService

  module Riot

    def self.find_game_by_summoner_id(summoner_id, region)
      Rails.logger.tagged('GAME'){Rails.logger.info("Find by summoner id")}
      platform_id = Consts::Platform.find_by_region(region)['platform']
      url = "https://#{region.downcase}.api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/#{platform_id}/#{summoner_id}"
      begin
        resp = RiotAPI.get(url, region)
      rescue Errors::NotFoundError => ex
        raise Errors::GameNotFoundError.new
      end
    end

    def self.find_current_featured_game(region)
      url = "https://#{region.downcase}.api.pvp.net/observer-mode/rest/featured"
      resp = RiotAPI.get(url, region)
    end

  end

  module Service

    def self.find_current_featured_games(region)
      region.upcase!
      unless r = find_featured_games_from_cache(region)
        r = {}
        featured = Riot.find_current_featured_game(region)
        r['game_list'] = featured['game_list'].map{|g| Factory.build_game_hash(g, region)}
        store_featured_games_to_cache(r, region)
      end
      r
    end

    def self.find_game_by_summoner_name(summoner_name, region)
      raise Errors::SummonerNotFoundError.new if summoner_name.blank? || region.blank?
      summoner = Summoner::Service.find_summoner_by_summoner_name(summoner_name, region)
      find_game_by_summoner_id(summoner.summoner_id, region)
    end

    def self.find_game_by_summoner_id(summoner_id, region)
      raise Errors::SummonerNotFoundError.new if summoner_id.blank? || region.blank?
      region.upcase!

      start_time = Time.now

      # check cache
      game_in_cache = find_game_from_cache(summoner_id, region)

      if game_in_cache.blank? # if no game found, fetch
        # check riot
        json = Riot.find_game_by_summoner_id(summoner_id, region)
        game_id = json['game_id']

        # check db
        game = Game.where('game_id' => game_id).first
        unless game # game not found in db
          # fetch game
          game_hash = Factory.build_game_hash(json, region)
          summoners_hash = game_hash['teams'].map{|t|t['participants']}.flatten
          summoner_ids = summoners_hash.map{|s|s['summoner_id']}

          # lock
          store_game_attrs_to_cache(game_id, nil, summoner_ids, region)

          # store summoner in db if not exist
          summoners = ensure_summoners_in_db(summoners_hash, region)

          # create game
          game = Game.new(game_hash)

          # add summoners to game
          store_summoners_info_to_game(summoners, game, region)

          # save game
          game.fetch_time_length = (Time.now - start_time).to_i
          game.save
          Rails.logger.tagged('GAME'){Rails.logger.info("Fetch took #{game.fetch_time_length} seconds")}
        end

        # cache game for a short time
        store_game_to_cache(game, region)
      else # if game found
        game = find_game_from_cache_waiting(summoner_id, region, AppConsts::FETCH_GAME_MAX_SECONDS)
      end

      game
    end

    def self.find_game_from_cache_waiting(summoner_id, region, wait_time)
      game = nil
      waited_time = 0
      check_game_thread = Thread.new do
        loop do
          Rails.logger.tagged('GAME'){Rails.logger.info("Wait for fetch: #{waited_time} / #{wait_time}")}
          game_in_cache = find_game_from_cache(summoner_id, region)
          completed = game_in_cache['fetch_completed']
          if completed # if fetch completed, done
            game = game_in_cache['game']
            break
          else
            sleep(2)
            raise Errors::GameNotFoundError.new if waited_time > wait_time
            waited_time += 2
          end
        end

        raise Errors::GameNotFoundError.new if game.blank?
      end
      check_game_thread.join
      game
    end

    def self.find_game_from_cache(summoner_id, region)
      Rails.logger.tagged('GAME'){Rails.logger.debug("Find in cache...")}
      region.upcase!
      summoner_game_key = cache_key_for_summoner_game(summoner_id, region)
      game = nil
      if summoner_game = Rails.cache.read(summoner_game_key)
        game_id = summoner_game['game_id']
        game_key = cache_key_for_game(game_id, region)
        game = Rails.cache.read(game_key)
      end
      game
    end

    def self.store_game_attrs_to_cache(game_id, game, summoner_ids, region)
      Rails.logger.tagged('GAME'){Rails.logger.debug("Store game #{game_id} #{game.nil? ? 'lock' : 'json'} to cache")}
      region.upcase!
      game_key = cache_key_for_game(game_id, region)
      hash = {
        'fetch_completed' => !game.blank?,
        'game' => game
      }
      Rails.cache.write(game_key, hash, expires_in: $game_expires_threshold)
      summoner_ids.each do |summoner_id|
        summoner_game_key = cache_key_for_summoner_game(summoner_id, region)
        summoner_game = {'game_id' => game_id}
        Rails.cache.write(summoner_game_key, summoner_game, expires_in: AppConsts::GAME_EXPIRES_THRESHOLD)
      end
    end

    def self.store_game_to_cache(game, region)
      store_game_attrs_to_cache(game.game_id, game, game.summoner_ids, region)
    end

    def self.find_featured_games_from_cache(region)
      region.upcase!
      cache_key = cache_key_for_featured_games(region)
      Rails.cache.read(cache_key)
    end

    def self.store_featured_games_to_cache(featured, region)
      region.upcase!
      cache_key = cache_key_for_featured_games(region)
      Rails.cache.write(cache_key, featured, expires_in: AppConsts::GAME_EXPIRES_THRESHOLD*2)
    end

    def self.store_summoners_info_to_game(summoners, game, region)
      workers = []
      game.teams.each do |team|
        team.participants.each do |participant|
          summoner_id = participant.summoner_id
          champion_id = participant.champion_id
          summoner = summoners.find{|s|s.summoner_id==summoner_id}
          participant.meta['twitch_channel'] = summoner.try(:twitch_channel)
          workers << Thread.new do
            begin
              # summoner season stats
              summoner_stat = SummonerStat::Service.find_summoner_season_stats(summoner_id, region)
            rescue
              # that means this summoner has not played ranked games
            end

            # if no rank stats, do not proceed
            next if summoner_stat.blank?

            begin
              champ_status = summoner_stat.ranked_stats_by_champion.select{|s|s.champion_id==champion_id}.first
              participant.ranked_stat_by_champion = champ_status.try(:clone)
            rescue => ex
              begin
                Airbrake.notify_or_ignore(ex,
                parameters: {
                  'action' => 'Generate summoner season stats',
                  'summoner_stat' => summoner_stat.try(:as_json),
                  'champ_status' => champ_status.try(:as_json),
                  'participant' => participant.try(:as_json)
                })
              rescue
              end
            end

            begin
              # all matches
              match_list_json = MatchService::Riot.find_match_list(summoner_id, region)

              # player roles
              player_roles_json = MatchService::Factory.build_player_roles(match_list_json)
              summoner_stat.update_attributes({:player_roles => player_roles_json})
              participant.player_roles = summoner_stat.aggregate_player_roles
            rescue => ex
              begin
                Airbrake.notify_or_ignore(ex,
                parameters: {
                  'action' => 'Generate player roles from match list',
                  'summoner_stat' => summoner_stat.try(:as_json),
                  'participant' => participant.try(:as_json)
                })
              rescue
              end
            end

            begin
              # last match
              matches = match_list_json.try(:[],'matches') || []
              last_match_json = matches.find{|m|m['champion'].try(:to_i) == champion_id.to_i}
              if last_match_json
                last_match = MatchService::Service.find_match(last_match_json['match_id'], region)
                last_match_stats = last_match.find_match_stats_for_summoner(summoner_id)
                match_stats_aggregation = MatchService::Service.get_matches_aggregation_for_participants([last_match_stats])
                participant.ranked_stat_by_recent_champion = match_stats_aggregation
              end
            rescue => ex
              begin
                Airbrake.notify_or_ignore(ex,
                parameters: {
                  'action' => 'Generate recent stats form last match',
                  'matches' => matches.try(:as_json),
                  'last_match_json' => last_match_json.try(:as_json),
                  'participant' => participant.try(:as_json)
                })
              rescue
              end
            end
          end

          workers << Thread.new do
            begin
              league = LeagueService::Service.find_league_by_summoner_id(summoner_id, region)
              league_entry = league.entries.find{|l| l['player_or_team_id'].to_i == summoner_id.to_i}
              league_entry['tier'] = league.tier
              participant.league_entry = league_entry
            rescue
            end
          end
        end
      end
      workers.map(&:join)
    end

    def self.update_summoners_tiers(summoner, recent_stats, region)
      if stat = recent_stats.first
        summoner.highest_tier = stat['highest_achieved_season_tier']
        summoner.save
      end
    end

    def self.ensure_summoners_in_db(summoners_hash, region)
      Rails.logger.tagged('GAME'){Rails.logger.debug("Store summoners to db")}
      summoners = []
      summoners_hash.each do |summoner_hash|
        summoner_obj_hash = {
          'region' => region.upcase,
          'summoner_id' => summoner_hash['summoner_id'],
          'name' => summoner_hash['summoner_name'],
          'profile_icon_id' => summoner_hash['profile_icon_id']
        }
        if summoner = Summoner.where({region: region.upcase, summoner_id: summoner_hash['summoner_id']}).first
          if summoner.name != summoner_hash['summoner_name']
            summoner.update_attributes(summoner_obj_hash)
          end
        else
          summoner = Summoner.create(summoner_obj_hash)
        end
        summoners << summoner
      end
      summoners
    end

    def self.cache_key_for_summoner_game(summoner_id, region)
      "summoner_game?region=#{region.upcase}&summoner=#{summoner_id}"
    end

    def self.cache_key_for_game(game_id, region)
      "game?region=#{region.upcase}&game_id=#{game_id}"
    end

    def self.cache_key_for_featured_games(region)
      "featured?region=#{region.upcase}"
    end

  end

  module Factory

    def self.build_game_hash(game, region)
      region.upcase!
      teams = game['participants'].group_by{|x|x['team_id']}
      r = Utils::JsonParser.clone_to([
        'game_id', 'map_id', 'game_mode', 'game_type', 'game_queue_config_id',
        'platform_id', 'game_length'
      ],game,{})
      r['region'] = region
      r['observer_encryption_key'] = game['observers'] ? game['observers']['encryption_key'] : nil,
      r['started_at'] = game['game_start_time']
      r['teams'] = teams.map{|k,v|build_team_hash(k,v,(game['banned_champions']||[]).select{|x|x['team_id']==k})}
      r
    end

    def self.build_team_hash(team_id, participants, bans)
      bans.each{|b|b.delete('team_id')}
      participants.each{|p|p.delete('team_id')}

      {
        'team_id' => team_id,
        'banned_champions' => bans,
        'participants' => participants
      }
    end


  end

end