angular.module('leaguegg.home').controller('HomeCtrl', [
  '$scope', 'LayoutService',
  function($scope, LayoutService) {
    LayoutService.setBGImg('/static/img/bg-blur.png');
  }
]);