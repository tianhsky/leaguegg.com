angular.module('leaguegg.summoner').directive('summonerRankedChampions', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/summoner/_ranked_champions.html',
    scope: {
      'stats': '=',
      'season': '='
    },
    controller: ['$scope',
      function($scope) {

      }
    ]
  }
});