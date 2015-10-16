angular.module('utils').directive('bgimg', [
  function() {
    return {
      restrict: 'E',
      templateUrl: 'static/partials/bgimg.html',
      controller: ['$scope', '$rootScope', '_',
        function($scope, $rootScope, _) {
          $rootScope.$watch('layoutProperties', function(newVal, oldVal) {
            var img_url = newVal.bgImg;
            var img = $('#bg-img');
            if (!_.isEmpty(img_url)) {
              img.attr('style', 'display:"";' + "background-image:url(" + img_url + ");");
            } else {
              img.attr('style', 'display:"none"; background-image:"none"');
            }
          }, true);
        }
      ]
    };
  }
]);