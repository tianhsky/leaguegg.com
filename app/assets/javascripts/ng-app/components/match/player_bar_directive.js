angular.module('leaguegg.match').directive('playerBar', function() {
  return {
    restrict: 'AE',
    templateUrl: 'static/match/player_bar.html',
    replace: true,
    scope: {
      'currentFrame': '=',
      'totalFrames': '=',
      'status': '=',
      'play': '&',
      'pause': '&',
      'stop': '&'
    },
    controller: [
      '$scope',
      function($scope) {
        var regObserver = function() {
          $('.player-bar').bind('click', function(ev) {
            var target = $(ev.target);
            var offset = target.offset();
            var x = ev.clientX - offset.left;
            var total = $('.player-bar').width();
            var percent = x / total;
            var frame = Math.round($scope.totalFrames * percent);
            if (frame < 0) {
              frame = 0;
            }
            if (frame > $scope.totalFrames - 1) {
              frame = $scope.totalFrames - 1;
            }
            $scope.$apply(function() {
              $scope.currentFrame = frame;
              if($scope.status == 'finished'){
                $scope.status = 'paused';
              }
            })
          });
        }
        regObserver();

        var seekFrame = function(frame) {
          var percent = frame / ($scope.totalFrames - 1);
          var percentVal = Math.round(percent * 100);
          var val = percentVal + "%";
          $('.player-progress').width(val);
        }

        $scope.$watch('currentFrame', function(nv, ov) {
          seekFrame(nv);
        });

        $scope.replay = function() {
          $scope.stop();
          $scope.play();
        }

      }
    ]
  }
});