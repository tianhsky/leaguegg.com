angular.module('leaguegg.summoner').service('SummonerService', [
  '$http', '$q', '_',
  function($http, $q, _) {
    var self = this;

    var _data = {
      query: {
        summoner: null,
        region: null
      },
      result: {
        summoner: null,
        season_stats: null
      }
    };

    var isQueryChanged = function(region, summoner_name) {
      return region != _data.query.region || summoner_name != _data.query.summoner
    }

    self.fetchSummonerInfo = function(region, summoner_name) {
      _data.query.region = region;
      _data.query.summoner = summoner_name;
      _data.result.season_stats = null;
      var url = '/api/summoner.json?summoner_name=' + summoner_name + '&region=' + region;
      return $http.get(url)
        .then(function(resp) {
          _data.result.summoner = resp.data;
          return resp.data;
        }, function(err) {
          return err;
        });
    }

    self.getSummonerInfo = function(region, summoner_name) {
      var shouldFetch = false;
      if (isQueryChanged(region, summoner_name)) {
        shouldFetch = true;
      } else {
        shouldFetch = _data.result.summoner ? false : true;
      }

      if (shouldFetch) {
        return self.fetchSummonerInfo(region, summoner_name);
      } else {
        return $q(function(resolve, reject) {
          resolve(_data.result.summoner);
        });
      }
    }

    self.fetchSummonerSeasonStats = function(region, summoner_id) {
      var url = '/api/summoner/stats.json?season_stats=1&summoner_id=' + summoner_id + '&region=' + region;
      return $http.get(url)
        .then(function(resp) {
          _data.result.summoner_stats = resp.data;
          return resp.data;
        }, function(err) {
          return err;
        });
    }

    self.getSummonerSeasonStats = function(region, summoner_id) {
      var shouldFetch = false;
      shouldFetch = _data.result.season_stats ? false : true;

      if (shouldFetch) {
        return self.fetchSummonerSeasonStats(region, summoner_id);
      } else {
        return $q(function(resolve, reject) {
          resolve(_data.result.season_stats);
        });
      }
    }

    self.fetchSummonerChampionStats = function(region, summoner_id, champion_id) {
      var url = '/api/summoner/stats.json?champion_stats=1&summoner_id=' + summoner_id + '&champion_id=' + champion_id + '&region=' + region;
      return $http.get(url)
        .then(function(resp) {
          _data.result.summoner_stats = resp.data;
          return resp.data;
        }, function(err) {
          return err;
        });
    }


  }
]);