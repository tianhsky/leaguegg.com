# Services related to current game, fetch live game status from riot or cache
module GameService

  module Riot

    def self.find_game_by_summoner_id(summoner_id, region)
      platform_id = Consts::Platform.find_by_region(region)['platform']
      url = "https://#{region.downcase}.api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/#{platform_id}/#{summoner_id}"
      begin
        resp = HttpService.get(url, region)
      rescue Errors::NotFoundError => ex
        raise Errors::GameNotFoundError
      end
    end

    def self.find_current_featured_game(region)
      url = "https://#{region.downcase}.api.pvp.net/observer-mode/rest/featured"
      resp = HttpService.get(url, region)
    end

  end

  module Service

    def self.find_current_featured_games(region)
      region.upcase!
      unless r = find_featured_games_from_cache(region)
        r = {}
        featured = Riot.find_current_featured_game(region)
        r['game_list'] = featured['gameList'].map{|g| Factory.build_game_hash(g, region)}
        store_featured_games_to_cache(r, region)
      end
      r
    end

    def self.find_game_by_summoner_name(summoner_name, region)
      raise Errors::SummonerNotFoundError if summoner_name.blank? || region.blank?
      summoner = Summoner::Service.find_summoner_by_summoner_name(summoner_name, region)
      find_game_by_summoner_id(summoner.summoner_id, region)
    end

    def self.find_game_by_summoner_id(summoner_id, region)
      raise Errors::SummonerNotFoundError if summoner_id.blank? || region.blank?
      region.upcase!

      # check cache
      unless game = find_game_from_cache(summoner_id, region)
        # check riot
        json = Riot.find_game_by_summoner_id(summoner_id, region)
        game_id = json['gameId']

        # check db
        unless game = Game.where('game_id' => game_id).first
          game_hash = Factory.build_game_hash(json, region)

          # store summoner in db if not exist
          summoners_hash = game_hash['teams'].map{|t|t['participants']}.flatten
          summoners = ensure_summoners_in_db(summoners_hash, region)

          # create game
          game = Game.new(game_hash)
          store_summoners_info_to_game(summoners, game, region)

          # save game
          game.save
        end

        # cache game for a short period
        store_game_to_cache(game, region)
      end
      game
    end

    def self.find_game_by_summoner_id2(summoner_id, region)
      # game
      game_json = Riot.find_game_by_summoner_id(summoner_id, region)
      game_id = game_json['gameId']
      game_hash = Factory.build_game_hash(game_json, region)

      # summoners
    end

    def self.find_game_from_cache(summoner_id, region)
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

    def self.store_game_to_cache(game, region)
      region.upcase!
      summoner_ids = game.summoner_ids
      game_id = game.game_id
      game_key = cache_key_for_game(game_id, region)
      Rails.cache.write(game_key, game, expires_in: $game_expires_threshold)
      summoner_ids.each do |summoner_id|
        summoner_game_key = cache_key_for_summoner_game(summoner_id, region)
        summoner_game = {'game_id' => game_id}
        Rails.cache.write(summoner_game_key, summoner_game, expires_in: AppConsts::GAME_EXPIRES_THRESHOLD)
      end
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
          participant.meta['twitch_channel'] = summoner.twitch_channel if summoner
          workers << Thread.new do
            begin
              # summoner season stats
              summoner_stat = SummonerStat::Service.find_summoner_season_stats(summoner_id, region)
              champ_status = summoner_stat.ranked_stats_by_champion.select{|s|s.champion_id==champion_id}.first
              participant.ranked_stat_by_champion = champ_status.try(:clone)
            rescue
            end

            begin
              # all matches
              match_list_json = MatchService::Riot.find_match_list(summoner_id, region)

              # player roles
              player_roles_json = MatchService::Factory.build_player_roles(match_list_json)
              summoner_stat.update_attributes({:player_roles => player_roles_json})
              participant.player_roles = summoner_stat.aggregate_player_roles

              # last match
              last_match_json = MatchService::Factory.get_match_list_for(match_list_json, champion_id, 1)
              if last_match_json
                last_match = MatchService::Service.find_match(last_match_json['match_id'], region)
                match_stats_aggregation = MatchService::Service.get_match_aggregation(last_match)
                participant.ranked_stat_by_recent_champion = match_stats_aggregation
              end

            rescue
            end

            # begin
            #   recent_stats = SummonerMatch::Service.find_matches(summoner_id, champion_id, region, 0, 15)
            #   recent_stats_aggregation = SummonerMatch::Service.get_matches_aggregation(recent_stats, champion_id)
            #   participant.ranked_stat_by_recent_champion = recent_stats_aggregation
            # rescue
            # end
          end

          workers << Thread.new do
            begin
              league = LeagueService::Service.find_league_by_summoner_id(summoner_id, region)
              league_entry = league.entries.find{|l| l['player_of_team_id'].to_i == summoner_id.to_i}
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
      summoners = []
      summoners_hash.each do |summoner_hash|
        summoner_obj_hash = {
          'region' => region.upcase,
          'summoner_id' => summoner_hash[:summoner_id],
          'name' => summoner_hash[:summoner_name],
          'profile_icon_id' => summoner_hash[:profile_icon_id]
        }
        if summoner = Summoner.where({region: region.upcase, summoner_id: summoner_hash[:summoner_id]}).first
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
      teams = game['participants'].group_by{|x|x['teamId']}
      {
        'region' => region,
        'game_id' => game['gameId'],
        'map_id' => game['mapId'],
        'game_mode' => game['gameMode'],
        'game_type' => game['gameType'],
        'game_queue_config_id' => game['gameQueueConfigId'],
        'platform_id' => game['platformId'],
        'observer_encryption_key' => game['observers'] ? game['observers']['encryptionKey'] : nil,
        'started_at' => game['gameStartTime'],
        'game_length' => game['gameLength'],
        'teams' => teams.map{|k,v|build_team_hash(k,v,game['bannedChampions'].select{|x|x['teamId']==k})}
      }
    end

    def self.build_team_hash(team_id, participants, bans)
      {
        'team_id' => team_id,
        'banned_champions' => bans.map{|x|build_banned_champion_hash(x)},
        'participants' => participants.map{|x|build_participant_hash(x)}
      }
    end

    def self.build_banned_champion_hash(ban)
      {
        'champion_id' => ban['championId'],
        'pick_turn' => ban['pickTurn']
      }
    end

    def self.build_participant_hash(participant)
      r = {
        'spell1_id' => participant['spell1Id'],
        'spell2_id' => participant['spell2Id'],
        'champion_id' => participant['championId'],
        'summoner_id' => participant['summonerId'],
        'summoner_name' => participant['summonerName'],
        'profile_icon_id' => participant['profileIconId'],
        'bot' => participant['bot']
      }
      if participant['masteries']
        r['masteries'] = participant['masteries'].map{|x|build_mastery_hash(x)}
      end
      if participant['runes']
        r['runes'] = participant['runes'].map{|x|build_rune_hash(x)}
      end
      r
    end

    def self.build_mastery_hash(mastery)
      {
        'rank' => mastery['rank'],
        'mastery_id' => mastery['masteryId']
      }
    end

    def self.build_rune_hash(rune)
      {
        'count' => rune['count'],
        'rune_id' => rune['runeId']
      }
    end

  end

end