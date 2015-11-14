angular.module('leaguegg.layouts').service('LayoutService', [
  '$http', '$rootScope', '_',
  function($http, $rootScope, _) {
    var self = this;
    $rootScope.layoutProperties = {
      bgImg: null,
      showBGVideo: null,
      hideHeader: null,
      fatHeader: null,
      scrollChampions: null
    };

    self.setBGImg = function(url) {
      $rootScope.layoutProperties.bgImg = url;
    }

    self.setScrollBG = function(champions) {
      $rootScope.layoutProperties.scrollChampions = champions;
    }

    self.setBGVideoVisible = function(enable) {
      $rootScope.layoutProperties.showBGVideo = enable;
    }

    self.setFatHeader = function(enable) {
      $rootScope.layoutProperties.fatHeader = enable;
    }

    self.hideHeader = function(enable) {
      $rootScope.layoutProperties.hideHeader = enable;
    }

  }
]);