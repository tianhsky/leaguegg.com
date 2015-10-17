angular.module('leaguegg.summoner').directive('summonerChampionSummary', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/summoner/_champion_summary.html',
    scope: {
      'season': '=',
      'summoner': '=',
      'championSeasonStat': '=',
      'championRecentStat': '='
    },
    controller: ['$scope',
      function($scope) {

      }
    ]
  }
});