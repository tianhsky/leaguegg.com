angular.module('leaguegg.summoner').controller('SummonerChampionStatsCtrl', [
  '$scope', '$stateParams', '$filter', '_', 'LayoutService',
  'SummonerService', 'ConstsService', 'MetaService',
  function($scope, $stateParams, $filter, _, LayoutService,
    SummonerService, ConstsService, MetaService) {
    LayoutService.setFatHeader(false);
    MetaService.setTitle($stateParams.summoner + ' · ' + $stateParams.region);

    $scope.data = {
      summoner: null,
      summoner_stats: null,
      champion_stats: null,
      season: $filter('titleize')(ConstsService.season),
      error: {
        summoner: null,
        summoner_stats: null,
        champion_stats: null
      }
    }

    $scope.getChampionSeasonStats = function() {
      if (!$scope.data.summoner_stats) {
        return null;
      }
      var stats = $scope.data.summoner_stats.ranked_stats_by_champion;
      if (stats) {
        return _.find(stats, function(i) {
          return i.champion.id == $stateParams.champion;
        });
      } else {
        return null;
      }
    }

    SummonerService.getSummonerInfo($stateParams.region, $stateParams.summoner)
      .then(function(data) {
        $scope.data.summoner = data;
        MetaService.setTitle(data.name + ' · ' + data.region);
        MetaService.setDescription("League of Legends Season Stats for " + data.name + ' at ' + data.region);

        SummonerService.getSummonerSeasonStats($stateParams.region, data.id)
          .then(function(stats) {
            $scope.data.summoner_stats = stats;
          }, function(err) {
            $scope.data.error.summoner_stats = err;
          });

        SummonerService.fetchSummonerChampionStats($stateParams.region, $scope.data.summoner.id, $stateParams.champion)
          .then(function(stats) {
            $scope.data.champion_stats = stats;
          }, function(err) {
            $scope.data.error.champion_stats = err;
          });
      }, function(err) {
        $scope.data.error.summoner = err;
      });

    $scope.$on('$destroy', function() {
      MetaService.useDefault();
    });
  }
]);