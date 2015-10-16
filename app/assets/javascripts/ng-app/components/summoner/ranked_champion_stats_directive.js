angular.module('leaguegg.summoner').directive('summonerRankedChampionStats', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/summoner/_ranked_champion_stats.html',
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