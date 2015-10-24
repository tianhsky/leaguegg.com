angular.module('leaguegg.home').controller('AppCtrl', [
  '$scope', 'LayoutService', 'MetaService',
  function($scope, LayoutService, MetaService) {
    LayoutService.setFatHeader(true);
    LayoutService.setBGVideoVisible(true);
    MetaService.setTitle('League of Legends Stats Search App');
    MetaService.setDescription("LeagueGG's mobile application for android and ios");

    $scope.$on('$destroy', function() {
      LayoutService.setBGVideoVisible(false);
      MetaService.useDefault();
    })
  }
]);