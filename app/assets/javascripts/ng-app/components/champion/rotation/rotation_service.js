angular.module('leaguegg.champion').service('RotationService', [
  '$http', '_',
  function($http, _) {
    var self = this;

    self.getWeeklyChampions = function() {
      var url = "/api/rotation.json";
      return $http.get(url)
        .then(function(resp) {
          var data = resp.data;
          return data;
        }, function(resp) {
          console.log(resp);
        });
    }
    
  }
]);