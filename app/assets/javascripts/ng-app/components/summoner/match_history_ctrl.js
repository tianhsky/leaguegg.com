angular.module('leaguegg.summoner').controller('SummonerMatchHistoryCtrl', [
  '$scope', '$stateParams', '$filter', 'LayoutService',
  'SummonerService', 'ConstsService',
  'MetaService', 'Analytics',
  function($scope, $stateParams, $filter, LayoutService,
    SummonerService, ConstsService,
    MetaService, Analytics) {
    LayoutService.setFatHeader(false);
    MetaService.setTitle($stateParams.summoner + ' - ' + $stateParams.region + ' - Summoners - League of Legends');

    $scope.data = {
      tab: 'history',
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
          text: null,
          theme: 'default'
        },
        match_history: {
          active: true,
          text: null,
          theme: 'default'
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

          SummonerService.getSummonerMatches($stateParams.region, $stateParams.summoner, reload_if_outdated)
            .then(function(matches) {
              $scope.data.loading.match_history.active = false;
              $scope.data.match_history = matches;
            }, function(err) {
              $scope.data.loading.match_history.active = false;
              $scope.data.error.match_history = err;
            })
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