angular.module('leaguegg.layouts').service('LayoutService', [
  '$http', '_',
  function($http, _) {
    var self = this;
    var _obj = {
      bg_img_url: null
    };

    self.getBGProperty = function() {
      return _obj;
    }

    self.setBGImg = function(url){
      _obj.bg_img_url = url;
    }

  }
]);