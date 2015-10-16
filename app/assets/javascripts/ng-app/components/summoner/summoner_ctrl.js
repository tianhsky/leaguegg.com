angular.module('leaguegg.summoner').controller('SummonerCtrl', [
  '$scope', '$stateParams', '$filter', 'LayoutService',
  'SummonerService', 'ConstsService',
  function($scope, $stateParams, $filter, LayoutService,
    SummonerService, ConstsService) {
    LayoutService.setFatHeader(false);

    $scope.summoner = null;
    $scope.summoner_stats = null;
    $scope.season = $filter('titleize')(ConstsService.season);

    SummonerService.getSummonerInfo($stateParams.region, $stateParams.summoner)
      .then(function(data) {
        $scope.summoner = data;

        SummonerService.getSummonerSeasonStats($stateParams.region, data.id)
          .then(function(stats) {
            $scope.summoner_stats = stats;
          })
      });
  }
]);