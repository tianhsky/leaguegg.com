angular.module('leaguegg.partials').directive('ggTimelineChart', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/partials/charts/gg_timeline_chart.html',
    scope: {
      'timeline': '=',
      'timelineDiff': '=',
      'series': '='
    },
    controller: ['$scope',
      function($scope) {

        $scope.$watch('timeline', function(newVal, oldVal) {
          $scope.labels = $scope.getLabels();
          $scope.data = $scope.getData();
          $scope.series = $scope.getSeries();
        });

        $scope.getData = function() {
          var t1 = [0, 0, 0, 0];
          var t2 = [0, 0, 0, 0];
          if ($scope.timeline) {
            t1 = $scope.timeline;
            if ($scope.timelineDiff) {
              t2[0] = t1[0] + $scope.timelineDiff[0];
              t2[1] = t1[1] + $scope.timelineDiff[1];
              t2[2] = t1[2] + $scope.timelineDiff[2];
              t2[3] = t1[3] + $scope.timelineDiff[3];
            }
          }
          return [t1, t2]
        }

        $scope.getLabels = function() {
          return ['10m', '20m', '30m', 'end'];
        }

        $scope.getSeries = function() {
          return $scope.series;
        }

      }
    ]
  }
});