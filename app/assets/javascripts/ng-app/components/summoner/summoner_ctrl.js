angular.module('leaguegg.summoner').controller('SummonerCtrl', [
  '$scope', '$stateParams', '$filter', 'LayoutService',
  'SummonerService', 'ConstsService', 'MetaService',
  function($scope, $stateParams, $filter, LayoutService,
    SummonerService, ConstsService, MetaService) {
    LayoutService.setFatHeader(false);
    MetaService.setTitle($stateParams.summoner + ' · ' + $stateParams.region);

    $scope.data = {
      summoner: null,
      summoner_stats: null,
      season: $filter('titleize')(ConstsService.season)
    }

    SummonerService.getSummonerInfo($stateParams.region, $stateParams.summoner)
      .then(function(data) {
        $scope.data.summoner = data;
        MetaService.setTitle(data.name + ' · ' + data.region);
        MetaService.setDescription("League of Legends Season Stats for " + data.name + ' at ' + data.region);

        SummonerService.getSummonerSeasonStats($stateParams.region, data.id)
          .then(function(stats) {
            $scope.data.summoner_stats = stats;
          })
      });

    $scope.$on('$destroy', function() {
      MetaService.useDefault();
    });
  }
]);