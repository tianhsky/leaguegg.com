angular.module('leaguegg.summoner').directive('summonerRankedChampions', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/summoner/_ranked_champions.html',
    scope: {
      'stats': '=',
      'season': '='
    },
    controller: ['$scope', '$location', 'SummonerService',
      function($scope, $location, SummonerService) {
        $scope.viewChampionStats = function(champion) {
          var query = SummonerService.getQuery();
          var url = '/summoner/' + query.region + '/' + query.summoner + '/champion/' + champion.id;
          $location.path(url);
        }
      }
    ]
  }
});