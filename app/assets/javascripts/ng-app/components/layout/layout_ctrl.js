angular.module('leaguegg.layouts').controller('LayoutCtrl', [
  '$scope', '_', 'LayoutService',
  function($scope, _, LayoutService) {

    $scope.layoutBGStyle = function() {
      var style = "";
      var bgProperty = LayoutService.getBGProperty();
      var img = bgProperty.bg_img_url;
      if (!_.isEmpty(img)) {
        style = "background-image:url(" + img + ");";
      }
      return style;
    }

  }
]);