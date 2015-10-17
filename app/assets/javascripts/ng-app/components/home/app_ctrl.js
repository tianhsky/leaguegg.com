angular.module('leaguegg.home').controller('AppCtrl', [
  '$scope', 'LayoutService', 'MetaService',
  function($scope, LayoutService, MetaService) {
    LayoutService.setFatHeader(true);
    LayoutService.setBGVideoVisible(true);
    MetaService.setTitle('Mobile App');
    MetaService.setDescription('Android IOS app for LeagueGG.');

    $scope.$on('$destroy', function() {
      LayoutService.setBGVideoVisible(false);
      MetaService.useDefault();
    })
  }
]);