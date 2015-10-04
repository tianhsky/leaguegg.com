angular.module('leaguegg.game').controller('LiveGameCtrl', [
  '$scope', '$stateParams', 'LiveGameService',
  function($scope, $stateParams, LiveGameService) {
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

    $scope.game = null;
    $scope.error = null;

    LiveGameService.getGameBySummoner($scope.query)
      .then(function(resp) {
        $scope.error = null;
        $scope.game = resp;
        $scope.loading.game.active = false;
      })
      .then(function(err) {
        $scope.error = err;
        $scope.loading.game.active = false;
      });

  }
]);