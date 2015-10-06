angular.module('utils').directive('bgimg', [
  function() {
    return {
      restrict: 'E',
      templateUrl: 'static/partials/bgimg.html',
      controller: ['$scope', '_', 'LayoutService',
        function($scope, _, LayoutService) {
          $scope.layoutBGStyle = function() {
            var style = "";
            var bgProperty = LayoutService.getBGProperty();
            var img = bgProperty.bg_img_url;
            if (!_.isEmpty(img)) {
              style = "background-image:url(" + img + ");";
            } else {
              style = "display:none;"
            }
            return style;
          }
        }
      ]
    };
  }
]);