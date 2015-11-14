angular.module('leaguegg.home').controller('HomeCtrl', [
  '$scope', '$rootScope', 'LayoutService', 'RotationService',
  function($scope, $rootScope, LayoutService, RotationService) {
    // LayoutService.setFatHeader(false);
    // LayoutService.setBGVideoVisible(true);
    LayoutService.hideHeader(true);
    LayoutService.setBGImg('/static/img/lol-full.jpg');

    $scope.data = {};

    RotationService.getWeeklyChampions()
      .then(function(resp) {
        // LayoutService.setScrollBG(resp);
        $scope.data.free_champions = resp;
      });

    $scope.$on('$destroy', function() {
      LayoutService.hideHeader(false);
    });
  }
]);