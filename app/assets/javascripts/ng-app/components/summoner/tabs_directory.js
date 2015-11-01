angular.module('leaguegg.summoner').directive('summonerTabs', function() {
  return {
    restrict: 'AE',
    replace: true,
    templateUrl: 'static/summoner/_tabs.html',
    scope: {
      'tabCode': '='
    },
    controller: ['$scope', '$location', 'SummonerService',
      function($scope, $location, SummonerService) {
        $scope.goTo = function(tab) {
          var query = SummonerService.getQuery();
          var url = '/summoner/' + query.region + '/' + query.summoner;
          if (tab == 'performance') {
            $location.path(url);
          } else if (tab == 'history') {
            $location.path(url + '/matches');
          } else {

          }
        }
      }
    ]
  }
});