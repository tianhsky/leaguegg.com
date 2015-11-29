module StaticDataService

  module Riot

    def self.fetch_champions(region='na')
      # url = "https://global.api.pvp.net/api/lol/static-data/#{region.downcase}/v1.2/champion"
      url = "http://ddragon.leagueoflegends.com/cdn/5.23.1/data/en_US/champion.json"
      resp = RiotAPI.get(url, region)
    end

    def self.fetch_maps(region='na')
      # url = "https://global.api.pvp.net/api/lol/static-data/#{region.downcase}/v1.2/map"
      url = "http://ddragon.leagueoflegends.com/cdn/5.23.1/data/en_US/map.json"
      resp = RiotAPI.get(url, region)
    end

    def self.fetch_masteries(region='na')
      # url = "https://global.api.pvp.net/api/lol/static-data/#{region.downcase}/v1.2/mastery?masteryListData=all"
      url = "http://ddragon.leagueoflegends.com/cdn/5.23.1/data/en_US/mastery.json"
      resp = RiotAPI.get(url, region)
    end

    def self.fetch_runes(region='na')
      # url = "https://global.api.pvp.net/api/lol/static-data/#{region.downcase}/v1.2/rune?runeListData=all"
      url = "http://ddragon.leagueoflegends.com/cdn/5.23.1/data/en_US/rune.json "
      resp = RiotAPI.get(url, region)
    end

    def self.fetch_items(region='na')
      # url = "https://global.api.pvp.net/api/lol/static-data/#{region.downcase}/v1.2/item"
      url = "http://ddragon.leagueoflegends.com/cdn/5.23.1/data/en_US/item.json"
      resp = RiotAPI.get(url, region)
    end

    def self.fetch_spells(region='na')
      # url = "https://global.api.pvp.net/api/lol/static-data/#{region.downcase}/v1.2/summoner-spell"
      url = "http://ddragon.leagueoflegends.com/cdn/5.23.1/data/en_US/summoner.json"
      resp = RiotAPI.get(url, region)
    end

    def self.fetch_versions(region='na')
      url = "https://global.api.pvp.net/api/lol/static-data/#{region.downcase}/v1.2/versions"
      resp = RiotAPI.get(url, region)
    end

  end

end