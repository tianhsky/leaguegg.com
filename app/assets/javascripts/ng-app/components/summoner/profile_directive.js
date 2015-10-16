angular.module('leaguegg.summoner').directive('summonerProfile', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/summoner/_profile.html',
    scope: {
      'summoner': '='
    },
    controller: ['$scope',
      function($scope) {

      }
    ]
  }
});