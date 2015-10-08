angular.module('leaguegg.game').controller('LiveGameCtrl', [
  '$scope', '$stateParams', 'LiveGameService',
  'ConstsService', '$filter',
  function($scope, $stateParams, LiveGameService,
    ConstsService, $filter) {
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
        if (resp.data && resp.data.id == null) {
          $scope.error = "Sorry, there was a problem";
        } else {
          $scope.error = null;
          $scope.game = resp;
        }
      });

  }
]);