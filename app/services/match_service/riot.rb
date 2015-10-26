module MatchService

  module Riot

    def self.find_match(match_id, region, include_timeline=false)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v2.2/match/#{match_id}"
      if(include_timeline)
        url += '?includeTimeline=true'
      end
      resp = ::RiotAPI.get(url, region)
    end

    def self.find_match_list(summoner_id, region, season=ENV['CURRENT_SEASON'], champion_id=nil, begin_index=nil, end_index=nil)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v2.2/matchlist/by-summoner/#{summoner_id}?"
      url += "&seasons=#{season}" unless season.blank?
      url += "&championIds=#{champion_id}" unless champion_id.blank?
      url += "&beginIndex=#{begin_index}" unless begin_index.blank?
      url += "&endIndex=#{end_index}" unless end_index.blank?
      resp = ::RiotAPI.get(url, region)
    end

    def self.find_recent_matches(summoner_id, region)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v1.3/game/by-summoner/#{summoner_id}/recent"
      resp = ::RiotAPI.get(url, region)
    end
    
  end

end