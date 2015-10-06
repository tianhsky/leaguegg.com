angular.module('leaguegg.game').service('LiveGameService', [
  '$localStorage', '_', '$http',
  function($localStorage, _, $http) {
    var self = this;

    self.SetCacheQuery = function(query) {
      $localStorage.setObject('searchgame', query);
    }

    self.getCacheQuery = function() {
      return $localStorage.getObject('searchgame');
    }

    self.clearCacheQuery = function() {
      $localStorage.remove('searchgame');
    }

    self.getSearchQuery = function() {
      var query = self.getCacheQuery();
      if (_.isEmpty(query)) {
        query = {
          region: 'NA',
          summoner: null
        }
      }
      return query;
    }

    self.getSearchUrl = function(type, query) {
      var url = null;
      if (!_.isEmpty(query.region) && !_.isEmpty(query.summoner)) {
        if (type == 'json') {
          url = '/api/game.json?summoner_name=' + query.summoner + '&region=' + query.region;
        } else if (type == 'html') {
          url = "/game/" + query.region + "/" + query.summoner;
        }
      }
      return url;
    }

    self.getGameBySummoner = function(query) {
      var url = self.getSearchUrl('json', query);
      return $http.get(url)
        .then(function(resp) {
          return resp.data;
        }, function(err) {
          return err;
        });
    }

  }
]);