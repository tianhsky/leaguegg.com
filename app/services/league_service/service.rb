module LeagueService

  module Service

    def self.find_league_by_summoner_id(summoner_id, region)
      json = Riot.find_league_by_summoner_id(summoner_id, region)
      json = json.find{|x|x['participant_id'].to_s == summoner_id.to_s}
      return nil if json.blank?
      hash = Factory.build_league_hash(json, region)
      league = League.find_or_create_by({
        region: hash['region'].try(:upcase),
        tier: hash['tier'].try(:upcase),
        queue: hash['queue'].try(:upcase),
        name: hash['name'].try(:upcase)
      })
      league.update_attributes(hash)
      league
    end

    def self.entries_to_summoner_entry(summoner_id, region, league_entries)
      json = league_entries
      return nil if json.blank?
      summoner_league_json = nil
      json.each do |j|
        j['entries'].each do |e|
          if e['player_or_team_id'].to_i == summoner_id.to_i
            summoner_league_json = j
            break
          end
          break unless summoner_league_json.blank?
        end
      end
      hash = Factory.build_league_hash(summoner_league_json, region)
      hash
    end

    def self.find_league_entry_by_summoner_id(summoner_id, region)
      json = Riot.find_league_entries_by_summoner_ids([summoner_id], region).values.first
      entries_to_summoner_entry(summoner_id, region, json)
    end

  end

end