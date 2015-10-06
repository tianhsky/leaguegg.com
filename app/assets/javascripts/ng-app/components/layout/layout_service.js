angular.module('leaguegg.layouts').service('LayoutService', [
  '$http', '$rootScope', '_',
  function($http, $rootScope, _) {
    var self = this;

    self.setBGImg = function(url) {
      $rootScope.bgImg = url;
    }

    self.setBGVideoVisible = function(enable) {
      $rootScope.showBGVideo = enable;
    }

  }
]);