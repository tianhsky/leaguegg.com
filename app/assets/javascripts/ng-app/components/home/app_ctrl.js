angular.module('leaguegg.home').controller('AppCtrl', [
  '$scope', 'LayoutService',
  function($scope, LayoutService) {

    LayoutService.setBGVideoVisible(true);

    $scope.$on('$destroy', function() {
      LayoutService.setBGVideoVisible(false);
    })
  }
]);