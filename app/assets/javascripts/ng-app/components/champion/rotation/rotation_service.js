angular.module('leaguegg.champion').service('RotationService', [
  '$http', '$q', '_', 'Analytics',
  function($http, $q, _, Analytics) {
    var self = this;

    self.getWeeklyChampions = function() {
      Analytics.trackEvent('FreeChampion', 'SearchByRegion', 'NA', 1);
      var url = "/api/rotation.json";

      return $q(function(resolve, reject) {
        $http.get(url)
          .then(function(resp) {
            var data = resp.data;
            resolve(data);
          }, function(err) {
            reject(err);
          });
      });
    }

    self.getChampionNames = function(champions) {
      var names = _.map(champions, function(c) {
        return c.name;
      });
      return names;
    }

  }
]);