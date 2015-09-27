module StaticDataService

  module Riot

    def self.fetch_champions(region='na')
      url = "https://global.api.pvp.net/api/lol/static-data/#{region.downcase}/v1.2/champion"
      resp = HttpService.get(url, region)
    end

    def self.fetch_maps(region='na')
      url = "https://global.api.pvp.net/api/lol/static-data/#{region.downcase}/v1.2/map"
      resp = HttpService.get(url, region)
    end

    def self.fetch_masteries(region='na')
      url = "https://global.api.pvp.net/api/lol/static-data/#{region.downcase}/v1.2/mastery"
      resp = HttpService.get(url, region)
    end

    def self.fetch_runes(region='na')
      url = "https://global.api.pvp.net/api/lol/static-data/#{region.downcase}/v1.2/rune"
      resp = HttpService.get(url, region)
    end

    def self.fetch_items(region='na')
      url = "https://global.api.pvp.net/api/lol/static-data/#{region.downcase}/v1.2/item"
      resp = HttpService.get(url, region)
    end

    def self.fetch_spells(region='na')
      url = "https://global.api.pvp.net/api/lol/static-data/#{region.downcase}/v1.2/summoner-spell"
      resp = HttpService.get(url, region)
    end

    def self.fetch_versions(region='na')
      url = "https://global.api.pvp.net/api/lol/static-data/#{region.downcase}/v1.2/versions"
      resp = HttpService.get(url, region)
    end

  end

end