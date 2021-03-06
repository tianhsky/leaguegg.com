module MatchService

  module Stats

    PARSER_VERSION = 2

    def self.aggregate(match)
      return if self._updated?(match)

      self._gen_player_stats(match)

      self._stamp_version(match)
    end

    private

    def self._stamp_version(match)
      match.stats_parser_version = PARSER_VERSION
    end

    def self._updated?(match)
      return true if match.stats_parser_version == PARSER_VERSION
      false
    end

    def self._gen_player_stats(match)
      match.teams.each do |team|
        next if team['participants'].blank?
        total_kills = team['participants'].sum{|p|p['stats']['kills']||0}
        total_deaths = team['participants'].sum{|p|p['stats']['deaths']||0}
        total_assists = team['participants'].sum{|p|p['stats']['assists']||0}
        total_dmg = team['participants'].sum{|p|p['stats']['total_damage_dealt']||0}
        total_wards_placed = team['participants'].sum{|p|p['stats']['wards_placed']||0}
        team['participants'].each do |p|
          stat = p['stats']
          p['stats_aggretated'] = {
            'kda_rate' => ((stat['kills']+stat['assists']).to_f / (stat['deaths']==0?1:stat['deaths'])).round(3),
            'kill_rate' => (stat['kills'].to_f / total_kills).round(3),
            'death_rate' => (stat['deaths'].to_f / total_deaths).round(3),
            'assistc_rate' => (stat['assists'].to_f / total_assists).round(3),
            'killc_rate' => ((stat['kills']+stat['assists']).to_f / total_kills).round(3),
            'dmg_rate' => (stat['total_damage_dealt'].to_f / total_dmg).round(3),
            'wards_placed_rate' => (stat['wards_placed'].to_f / total_wards_placed).round(3)
          }
        end
      end
    end

  end

end