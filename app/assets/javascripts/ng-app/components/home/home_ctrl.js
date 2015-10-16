angular.module('leaguegg.home').controller('HomeCtrl', [
  '$scope', 'LayoutService',
  function($scope, LayoutService) {
    LayoutService.setFatHeader(true);
  }
]);