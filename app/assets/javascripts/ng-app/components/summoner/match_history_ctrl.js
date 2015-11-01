angular.module('leaguegg.summoner').controller('SummonerMatchHistoryCtrl', [
  '$scope', '$stateParams', '$filter', 'LayoutService',
  'SummonerService', 'MatchService', 'ConstsService',
  'MetaService', 'Analytics',
  function($scope, $stateParams, $filter, LayoutService,
    SummonerService, MatchService, ConstsService,
    MetaService, Analytics) {
    LayoutService.setFatHeader(false);
    MetaService.setTitle($stateParams.summoner + ' - ' + $stateParams.region + ' - Summoners - League of Legends');

    $scope.data = {
      summoner: null,
      match_history: null,
      season: $filter('titleize')(ConstsService.season),
      error: {
        summoner: null,
        match_history: null
      },
      loading: {
        summoner: {
          active: true,
          text: 'Loading summoner ...',
          theme: 'taichi'
        },
        match_history: {
          active: true,
          text: 'Loading matchi history ...',
          theme: 'taichi'
        }
      }
    }

    var updateHistory = function(reload_if_outdated) {
      $scope.data.loading.summoner.active = false;
      $scope.data.loading.match_history.active = true;

      SummonerService.getSummonerInfo($stateParams.region, $stateParams.summoner, true)
        .then(function(data) {
          $scope.data.summoner = data;
          $scope.data.loading.summoner.active = false;
          MetaService.setTitle(data.name + ' - ' + data.region_name + ' - Summoners - League of Legends');
          MetaService.setDescription(data.meta_description);

          // MatchService.getSummonerSeasonStats($stateParams.region, data.id, reload_if_outdated)
          //   .then(function(stats) {
          //     $scope.data.loading.match_history.active = false;
          //     $scope.data.match_history = stats;
          //   }, function(err) {
          //     $scope.data.loading.match_history.active = false;
          //     $scope.data.error.match_history = err;
          //   })
        }, function(err) {
          $scope.data.loading.summoner.active = false;
          $scope.data.error.summoner = err;
        });

    }

    updateHistory(false);


    $scope.$on('$destroy', function() {
      MetaService.useDefault();
    });
  }
]);