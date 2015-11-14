# Services related to current game, fetch live game status from riot or cache
module GameService

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
      summoner = SummonerService::Service.find_summoner_by_summoner_name(summoner_name, region)
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
          # fetch and new game
          game_hash = Factory.build_game_hash(json, region)
          game = Game.new(game_hash)

          # extract summoners info
          summoners_hash = game_hash['teams'].map{|t|t['participants']}.flatten
          summoner_ids = summoners_hash.map{|s|s['summoner_id']}

          # lock
          store_game_attrs_to_cache(game_id, nil, summoner_ids, region)

          # find or new summoners
          # summoners = SummonerService::Service.find_or_new_summoners(summoners_hash, region)
          summoners = SummonerService::Service.find_summoner_by_summoner_ids(summoner_ids, region, false)

          # add summoners to game
          store_summoners_info_to_game(summoners, game, region)

          # save summoners
          SummonerService::Service.store_summoners_to_db(summoners)

          # save game
          Thread.new do
            # begin
            store_game_to_cache(game, region)

            game.fetch_time_length = (Time.now - start_time).to_i
            Rails.logger.tagged('GAME'){Rails.logger.info("Fetch took #{game.fetch_time_length} seconds")}
            game.save
            # rescue
            # end
          end
        end

      else # if game found
        game = find_game_from_cache_waiting(summoner_id, region, AppConsts::FETCH_GAME_MAX_SECONDS)
      end

      game
    end

    def self.find_game_from_cache_waiting(summoner_id, region, wait_time)
      game = nil
      waited_time = 0

      loop do
        Rails.logger.tagged('GAME'){Rails.logger.info("Wait for fetch: #{waited_time} / #{wait_time}")}
        game_in_cache = find_game_from_cache(summoner_id, region)
        break if game_in_cache.blank?
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
      completed = !game.blank?
      hash = {
        'fetch_completed' => completed,
        'game' => game
      }
      expire_threshold = completed ? $game_expires_threshold : 30.seconds
      Rails.cache.write(game_key, hash, expires_in: expire_threshold)
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

      summoner_ids = summoners.map{|x|x.summoner_id}
      begin
        league_entries = LeagueService::Riot.find_league_entries_by_summoner_ids(summoner_ids, region)
      rescue => ex
      end

      game.teams.each do |team|
        team.participants.each do |participant|
          summoner_id = participant.summoner_id
          champion_id = participant.champion_id
          summoner = summoners.find{|s|s.summoner_id==summoner_id}
          participant.meta['twitch_channel'] = summoner.try(:twitch_channel)
          workers << Thread.new do
            begin
              # summoner season stats
              summoner_stat = SummonerStatService::Service.find_summoner_season_stats(summoner_id, region)
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
              match_list_json = MatchService::Riot.find_match_list(summoner_id, region, ENV['CURRENT_SEASON'], nil, 0, 60)

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
              matches = match_list_json.try(:[],'matches') || []
              match_stats_aggregation = MatchService::Service.get_matches_aggregation_for_last_x_matches(region, summoner_id, champion_id, 1, matches)
              participant.ranked_stat_by_recent_champion = match_stats_aggregation

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
              summoner_league_entries = league_entries[summoner_id.to_s]
              # summoner.touch_synced_at
              if league = LeagueService::Service.entries_to_summoner_entry(summoner_id, region, summoner_league_entries)
                summoner_league_entry = league['entries'].find{|l| l['player_or_team_id'].to_i == summoner_id.to_i}
                summoner_league_entry['tier'] = league['tier']
                participant.league_entry = summoner_league_entry
              end
            rescue
              begin
                Airbrake.notify_or_ignore(ex,
                parameters: {
                  'action' => 'Generate league entry',
                  'summoner_id' => summoner_id
                })
              rescue
              end
            end
          end
        end
      end

      workers.map(&:join)
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

    def self.store_current_featured_games(region='NA')
      featured = self.find_current_featured_games(region)
      featured['game_list'].each do |fg|
        summoner_name = fg['teams'][0]['participants'][0]['summoner_name']
        self.find_game_by_summoner_name(summoner_name, region)
      end
    end

  end

end