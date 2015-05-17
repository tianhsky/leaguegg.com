# Services related to current game, fetch live game status from riot or cache
module GameService

  module Riot

    def self.find_game_by_summoner_id(summoner_id, region)
      platform_id = Consts::Platform.find_by_region(region)['platform']
      url = "https://#{region.downcase}.api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/#{platform_id}/#{summoner_id}"
      begin
        resp = HttpService.get(url)
      rescue Errors::NotFoundError => ex
        raise Errors::GameNotFoundError
      end
    end

  end

  module Service

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
              summoner_stat = SummonerStat::Service.find_summoner_season_stats(summoner_id, region)
              champ_status = summoner_stat.ranked_stats_by_champion.select{|s|s.champion_id==champion_id}.first
              participant.ranked_stat_by_champion = champ_status.try(:clone)
            rescue
            end
            begin
              recent_stats = SummonerMatch::Service.find_recent_matches(summoner_id, champion_id, region)
              recent_stats_aggregation = SummonerMatch::Service.get_matches_aggregation(recent_stats, champion_id)
              participant.ranked_stat_by_recent_champion = recent_stats_aggregation
            rescue
            end
          end
        end
      end
      workers.map(&:join)
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
      {
        'spell1_id' => participant['spell1Id'],
        'spell2_id' => participant['spell2Id'],
        'champion_id' => participant['championId'],
        'summoner_id' => participant['summonerId'],
        'summoner_name' => participant['summonerName'],
        'profile_icon_id' => participant['profileIconId'],
        'bot' => participant['bot'],
        'masteries' => participant['masteries'].map{|x|build_mastery_hash(x)},
        'runes' => participant['runes'].map{|x|build_rune_hash(x)}
      }
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