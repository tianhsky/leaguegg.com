angular.module('leaguegg.champion').service('RotationService', [
  '$http', '$q', '_', 'Analytics',
  function($http, $q, _, Analytics) {
    var self = this;
    var _data = {
      champions: null
    };

    self.fetchWeeklyChampions = function() {
      // Analytics.trackEvent('FreeChampion', 'SearchByRegion', 'NA', 1);
      var url = "/api/rotation.json";
      return $q(function(resolve, reject) {
        $http.get(url)
          .then(function(resp) {
            _data.champions = resp.data;
            resolve(_data.champions);
          }, function(err) {
            reject(err);
          });
      });
    }

    self.getWeeklyChampions = function() {
      if (_data.champions) {
        return $q(function(resolve, reject) {
          resolve(_data.champions);
        });
      } else {
        return self.fetchWeeklyChampions();
      }
    }
    
    self.getChampionNames = function(champions) {
      var names = _.map(champions, function(c) {
        return c.name;
      });
      return names;
    }

  }
]);