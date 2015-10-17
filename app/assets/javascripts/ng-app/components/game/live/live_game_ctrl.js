angular.module('leaguegg.game').controller('LiveGameCtrl', [
  '$scope', '$stateParams', 'LiveGameService',
  'ConstsService', '$filter', 'LayoutService',
  function($scope, $stateParams, LiveGameService,
    ConstsService, $filter, LayoutService) {
    LayoutService.setFatHeader(false);

    $scope.loading = {
      game: {
        active: true,
        text: 'Loading game stats from RIOT ...',
        theme: 'taichi'
      }
    };
    $scope.query = {
      region: $stateParams.region,
      summoner: $stateParams.summoner
    }
    $scope.season = $filter('titleize')(ConstsService.season);
    $scope.game = null;
    $scope.error = null;

    LiveGameService.getGameBySummoner($scope.query)
      .then(function(resp) {
        $scope.loading.game.active = false;
        $scope.error = null;
        $scope.error_summoner_not_in_game = false;
        if (resp.data && resp.data.id == null) {
          if (resp.status == 404) {
            $scope.error = resp.data.error;
            if ($scope.error == 'Summoner is not currently in game') {
              $scope.error_summoner_not_in_game = true;
            }
          } else {
            $scope.error = "Sorry, there was a problem";
          }
        } else {
          // LiveGameService.applyOPGGUrl(resp);
          $scope.game = resp;
        }
      });

  }
]);