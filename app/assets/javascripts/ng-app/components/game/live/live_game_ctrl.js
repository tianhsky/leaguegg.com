angular.module('GameModule').controller('LiveGameCtrl', [
  '$scope', '$stateParams', 'LiveGameService',
  function($scope, $stateParams, LiveGameService) {
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
      })
      .then(function(err) {
        $scope.error = err;
      });

  }
]);