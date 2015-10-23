angular.module('leaguegg.summoner').directive('summonerRankedChampions', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/summoner/_ranked_champions.html',
    scope: {
      'stats': '=',
      'season': '=',
      'updateClicked': '&',
      'summonerStatsLoading': '='
    },
    controller: ['$scope', '$location', 'SummonerService',
      function($scope, $location, SummonerService) {
        $scope.searchFilter = {
          field: 'kda_rate',
          order: -1,
          expression: '-kda_rate'
        };
        $scope.sortBy = function(field) {
          var changed = (field != $scope.searchFilter.field);
          if (changed) {
            $scope.searchFilter.order = 1;
          } else {
            $scope.searchFilter.order *= -1;
          }
          $scope.searchFilter.field = field;

          var exp_prefix = $scope.searchFilter.order == -1 ? '-' : '';
          $scope.searchFilter.expression = exp_prefix + field;
        }
        $scope.viewChampionStats = function(champion) {
          var query = SummonerService.getQuery();
          var url = '/summoner/' + query.region + '/' + query.summoner + '/champion/' + champion.id;
          $location.path(url);
        };
      }
    ]
  }
});