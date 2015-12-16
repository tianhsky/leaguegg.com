angular.module('utils').directive('bgvid', [
  function() {
    return {
      restrict: 'E',
      templateUrl: 'static/partials/bgvid.html',
      controller: ['$scope', '$rootScope',
        function($scope, $rootScope) {

          var unbindWatcher = $rootScope.$watch('layoutProperties', function(newVal, oldVal) {
            var vid = $('#bg-vid');
            var enable = newVal.showBGVideo;
            if (enable) {
              var poster = '/static/img/lol-full.jpg';
              vid.attr('poster', poster);
              var src1 = $("<source>")
                .attr('src', 'http://s.lolstatic.com/site/2016-season-update/90a9750484633b004fe7c155321bd4e50f0e5ce0/video/preseason/preseason-hero-1080.mp4')
                .attr('type', 'video/mp4');
              vid.append(src1);
              // var src2 = $("<source>")
              //   .attr('src', 'static/video/home-bg.home-bg')
              //   .attr('type', 'video/webm');
              // vid.append(src2);
              vid.show();
            } else {
              vid.attr('poster', null);
              vid.empty();
              vid.hide();
            }
          }, true);

          $scope.$on('$destroy', function() {
            unbindWatcher();
          });
          
        }
      ]
    };

  }
]);