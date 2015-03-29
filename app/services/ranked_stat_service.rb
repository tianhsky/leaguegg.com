module RankedStatService

	class JsonParser
		def self.to_collection(json)
			stats = []
			json['champions'].each do |champion|
				stat = SummonerRankedStat.new({
					lol_champion_id: champion['id'],
					stats: champion['stats']
					})
				stats << stat
			end
			stats
		end
	end

	class Searcher
		def self.get_from_riot(summoner_id, season, region)
			resp = HttpService.get("https://na.api.pvp.net/api/lol/#{region}/v1.3/stats/by-summoner/#{summoner_id}/ranked?season=#{season}")
			resp.body
		end
	end

end