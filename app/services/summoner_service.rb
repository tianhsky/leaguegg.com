module SummonerService

	class Factory
		def self.to_collection(json)
			stats = []
			json['playerStatSummaries'].each do |summary|

				stat = SummonerPlayerSummary.new({
					player_stat_summary_type: summary['playerStatSummaryType'],
					wins: summary['wins'],
					lol_modified_at: summary['modifyDate'],
					aggregated_stats: summary['aggregatedStats']
					})
				stats << stat
			end
			stats
		end
	end

	class Searcher

		def self.find_summoner_by_id(summoner_id, region)
      resp = HttpService.get("https://#{region}.api.pvp.net/api/lol/#{region}/v1.4/summoner/#{summoner_id}")
      resp["#{summoner_id}"]
    end



	end


end