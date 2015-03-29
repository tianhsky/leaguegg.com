module GameService

  class Factory

    @json
    @region

    def initialize (json, region)
      @json = HashWithIndifferentAccess.new json
      @region = region
    end

    def to_obj
      game = Game.new(convert_json)
    end

    def convert_json
      teams = @json['participants'].group_by{|x|x['teamId']}
      {
        region: @region,
        match_id: @json['gameId'],
        map_id: @json['mapId'],
        match_mode: @json['gameMode'],
        match_type: @json['gameType'],
        game_queue_config_id: @json['gameQueueConfigId'],
        platform_id: @json['platformId'],
        observer_encryption_key: @json['observers'] ? @json['observers']['encryptionKey'] : nil,
        started_at: @json['gameStartTime'],
        game_length: @json['gameLength'],
        match_teams: teams.map{|k,v|convert_team(k,v)}
      }
    end

    private

    def convert_team(team_id, participants)
      bans = @json['bannedChampions'].select{|x|x['teamId']==team_id}
      {
        team_id: team_id,
        match_banned_champions: bans.map{|x|convert_ban(x)},
        match_participants: participants.map{|x|convert_participant(x)}
      }
    end

    def convert_ban(ban)
      {
        champion_id: ban['championId'],
        pick_turn: ban['pickTurn']
      }
    end

    def convert_participant(participant)
      {
        spell1_id: participant['spell1Id'],
        spell2_id: participant['spell2Id'],
        champion_id: participant['championId'],
        summoner_id: participant['summonerId'],
        summoner_name: participant['summoner_name'],
        profile_icon_id: participant['profileIconId'],
        bot: participant['bot'],
        match_masteries: participant['masteries'].map{|x|convert_mastery(x)},
        match_runes: participant['runes'].map{|x|convert_rune(x)}
      }
    end

    def convert_mastery(mastery)
      {
        rank: mastery['rank'],
        mastery_id: mastery['masteryId']
      }
    end

    def convert_rune(rune)
      {
        rank: rune['count'],
        rune_id: rune['runeId']
      }
    end
  end

  class Riot
    def self.find_game_by_summoner_id(summoner_id, region)
      platform_id = Enums::REGION_TO_PLATFORM[region.upcase]
      url = "https://#{region.downcase}.api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/#{platform_id}/#{summoner_id}"
      resp = HttpService.get(url)
    end

  end

  class Searcher

    def self.find_game_by_summonner_name(summoner_name, region)
    end

    def self.find_game_by_summoner_id(summoner_id, region)
      region.upcase!
      # check cache
      game = self.find_game_from_cache(summoner_id, region)
      # check riot
      unless game
        json = GameService::Riot.find_game_by_summoner_id(summoner_id, region)
        factory = GameService::Factory.new(json, region)
        game = factory.to_obj
        self.write_game_to_cache(game, summoner_id, region)
      end
      game
    end

    def self.find_game_from_cache(summoner_id, region)
      region.upcase!
      summoner_game_key = Game.cache_key_summoner_game(summoner_id, region)
      game = nil
      if summoner_game = Rails.cache.read(summoner_game_key)
        game_id = summoner_game[:game_id]
        game_key = Game.cache_key_game(game_id, region)
        game = Rails.cache.read(game_key)
      end
      game
    end

    def self.write_game_to_cache(game, summoner_id, region)
      region.upcase!
      game_id = game.match_id
      game_key = Game.cache_key_game(game_id, region)
      Rails.cache.write(game_key, game, expires_in: $game_expires_threshold)
      game.summoner_ids.each do |sum_id|
        summoner_game_key = Game.cache_key_summoner_game(sum_id, region)
        summoner_game = {game_id: game_id}
        Rails.cache.write(summoner_game_key, summoner_game, expires_in: $game_expires_threshold)
      end
    end

  end

end