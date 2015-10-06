angular.module('utils').directive('bgimg', [
  function() {
    return {
      restrict: 'E',
      templateUrl: 'static/partials/bgimg.html',
      controller: ['$scope', '$rootScope', '_',
        function($scope, $rootScope, _) {
          $rootScope.$watch('bgImg', function(newVal, oldVal) {
            if (!_.isEmpty(newVal)) {
              var img = $('#bg-img');
              var img_url = newVal;
              if (!_.isEmpty(img_url)) {
                img.attr('style', 'display:"";' + "background-image:url(" + img_url + ");");
              } else {
                img.attr('style', 'display:"none"; background-image:"none"');
              }
            }
          });
        }
      ]
    };
  }
]);