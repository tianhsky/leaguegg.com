angular.module('leaguegg.summoner').controller('SummonerCtrl', [
  '$scope', '$stateParams', '$filter', 'LayoutService',
  'SummonerService', 'ConstsService', 'MetaService', 'Analytics',
  function($scope, $stateParams, $filter, LayoutService,
    SummonerService, ConstsService, MetaService, Analytics) {
    LayoutService.setFatHeader(false);
    LayoutService.setBGImg('/static/img/bg-sand.png');
    MetaService.setTitle($stateParams.summoner + ' - ' + $stateParams.region + ' - Summoners - League of Legends');

    $scope.data = {
      tab: 'performance',
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
          text: null,
          theme: 'default'
        },
        summoner_stats: {
          active: true,
          text: null,
          theme: 'default'
        }
      }
    }

    $scope.updateClicked = function(){
      updateStats(true);
      Analytics.trackEvent('Summoner', 'UpdateInfo', $stateParams.summoner + '@' + $stateParams.region, 1);
    }

    var updateStats = function(reload_if_outdated) {
      $scope.data.loading.summoner.active = false;
      $scope.data.loading.summoner_stats.active = true;

      SummonerService.getSummonerInfo($stateParams.region, $stateParams.summoner, true)
        .then(function(data) {
          $scope.data.loading.summoner.active = false;
          $scope.data.summoner = data;
          MetaService.setTitle(data.name + ' - ' + data.region_name + ' - Summoners - League of Legends');
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

    updateStats(true);


    $scope.$on('$destroy', function() {
      MetaService.useDefault();
    });
  }
]);