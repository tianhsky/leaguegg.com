angular.module('utils').directive('bgvid', [
  function() {
    return {
      restrict: 'E',
      templateUrl: 'static/partials/bgvid.html',
      controller: ['$scope', '$rootScope',
        function($scope, $rootScope) {
          $rootScope.$watch('showBGVideo', function(enable, wasEnabled) {
            var vid = $('#bg-vid');
            if (enable) {
              var poster = 'static/img/home-bg.png';
              var src1 = $("<source>")
                .attr('src', 'static/video/home-bg.mp4')
                .attr('type', 'video/mp4');
              var src2 = $("<source>")
                .attr('src', 'static/video/home-bg.home-bg')
                .attr('type', 'video/webm');
              vid.attr('poster', poster);
              vid.append(src1).append(src2);
              vid.show();
            } else {
              vid.attr('poster', null);
              vid.empty();
              vid.hide();
            }
          });
        }
      ]
    };

  }
]);