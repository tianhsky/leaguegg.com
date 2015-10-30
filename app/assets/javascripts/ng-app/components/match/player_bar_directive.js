angular.module('leaguegg.match').directive('playerBar', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/match/player_bar.html',
    scope: {
      'currentFrame': '=',
      'totalFrames': '=',
      'status': '=',
      'seek': '&',
      'play': '&',
      'pause': '&',
      'stop': '&'
    },
    controller: [
      '$scope',
      function($scope) {
        var regObserver = function() {
          $('.player-bar').bind('click', function(ev) {

            var $div = $(ev.target);
            var $display = $div.find('.player-display');

            var offset = $div.offset();
            var x = ev.clientX - offset.left;

            $('.player-progress').width(x);

          });
        }

        $scope.$watch('currentFrame', function(nv, ov) {
          var percent = nv / ($scope.totalFrames-1);
          var val = (percent * 100) + "%";
          $('.player-progress').width(val);
        });

      }
    ]
  }
});