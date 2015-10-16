angular.module('leaguegg.layouts').service('LayoutService', [
  '$http', '$rootScope', '_',
  function($http, $rootScope, _) {
    var self = this;
    $rootScope.layoutProperties = {
      bgImg: null,
      showBGVideo: null,
      fatHeader: null
    };

    self.setBGImg = function(url) {
      $rootScope.layoutProperties.bgImg = url;
    }

    self.setBGVideoVisible = function(enable) {
      $rootScope.layoutProperties.showBGVideo = enable;
    }

    self.setFatHeader = function(enable){
      $rootScope.layoutProperties.fatHeader = enable;
    }

  }
]);