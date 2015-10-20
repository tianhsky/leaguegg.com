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
      season: $filter('titleize')(ConstsService.season),
      error: {
        summoner: null,
        summoner_stats: null
      },
      loading: {
        summoner: {
          active: true,
          text: 'Loading summoner ...',
          theme: 'taichi'
        },
        summoner_stats: {
          active: true,
          text: 'Loading summoner stats ...',
          theme: 'taichi'
        }
      }
    }

    $scope.updateStats = function(reload_if_outdated) {
      $scope.data.loading.summoner.active = false;
      $scope.data.loading.summoner_stats.active = true;

      SummonerService.getSummonerInfo($stateParams.region, $stateParams.summoner, reload_if_outdated)
        .then(function(data) {
          $scope.data.summoner = data;
          $scope.data.loading.summoner.active = false;
          MetaService.setTitle(data.name + ' · ' + data.region);
          MetaService.setDescription(data.meta_description);
          
          SummonerService.getSummonerSeasonStats($stateParams.region, data.id, reload_if_outdated)
            .then(function(stats) {
              $scope.data.loading.summoner_stats.active = false;
              $scope.data.summoner_stats = stats;
            }, function(err) {
              $scope.data.loading.summoner_stats.active = false;
              $scope.data.error.summoner_stats = err;
            })
        }, function(err) {
          $scope.data.loading.summoner.active = false;
          $scope.data.error.summoner = err;
        });

    }

    $scope.updateStats(false);


    $scope.$on('$destroy', function() {
      MetaService.useDefault();
    });
  }
]);