angular.module('leaguegg.summoner').controller('SummonerChampionStatsCtrl', [
  '$scope', '$stateParams', '$filter', '_', 'LayoutService',
  'SummonerService', 'ConstsService', 'MetaService',
  function($scope, $stateParams, $filter, _, LayoutService,
    SummonerService, ConstsService, MetaService) {
    LayoutService.setFatHeader(false);
    MetaService.setTitle($stateParams.summoner + ' - ' + $stateParams.region + ' - Summoners - League of Legends');
    $scope.data = {
      summoner: null,
      summoner_stats: null,
      champion_stats: null,
      season: $filter('titleize')(ConstsService.season),
      loading: {
        summoner: {
          active: true,
          text: null,
          theme: 'default'
        },
        summoner_stats: {
          active: true,
          text: null,
          theme: 'default'
        },
        champion_stats: {
          active: true,
          text: null,
          theme: 'default'
        }
      },
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

    var loadData = function() {
      $scope.data.loading.summoner.active = false;
      $scope.data.loading.summoner_stats.active = true;
      $scope.data.loading.champion_stats.active = true;

      SummonerService.getSummonerInfo($stateParams.region, $stateParams.summoner, false)
        .then(function(data) {
          $scope.data.loading.summoner.active = false;
          $scope.data.summoner = data;
          MetaService.setTitle(data.name + ' - ' + data.region_name + ' - Summoners - League of Legends');
          MetaService.setDescription(data.meta_description);

          SummonerService.getSummonerSeasonStats($stateParams.region, data.id)
            .then(function(stats) {
              $scope.data.loading.summoner_stats.active = false;
              $scope.data.summoner_stats = stats;
            }, function(err) {
              $scope.data.loading.summoner_stats.active = false;
              $scope.data.error.summoner_stats = err;
            });

          SummonerService.fetchSummonerChampionStats($stateParams.region, $scope.data.summoner.id, $stateParams.champion)
            .then(function(stats) {
              $scope.data.loading.champion_stats.active = false;
              $scope.data.champion_stats = stats;
            }, function(err) {
              $scope.data.loading.champion_stats.active = false;
              $scope.data.error.champion_stats = err;
            });
        }, function(err) {
          $scope.data.loading.summoner.active = false;
          $scope.data.error.summoner = err;
        });
    }

    loadData();

    $scope.$on('$destroy', function() {
      MetaService.useDefault();
    });
  }
]);