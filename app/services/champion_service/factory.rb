module ChampionService

  module Factory

    def self.build_champions_hash(json)
      champions = json.map do |c|
        champ = Consts::Champion.find_by_id(c['id'])
        c.merge!(champ)
      end
      champions
    end

  end

end