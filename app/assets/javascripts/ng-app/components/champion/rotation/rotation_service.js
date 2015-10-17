angular.module('leaguegg.champion').service('RotationService', [
  '$http', '_', 'Analytics',
  function($http, _, Analytics) {
    var self = this;

    self.getWeeklyChampions = function() {
      Analytics.trackEvent('FreeChampion', 'SearchByRegion', 'NA', 1);
      var url = "/api/rotation.json";
      return $http.get(url)
        .then(function(resp) {
          var data = resp.data;
          return data;
        }, function(err) {
          return err;
        });
    }

    self.getChampionNames = function(champions){
      var names = _.map(champions, function(c){
        return c.name;
      });
      return names;
    }

  }
]);