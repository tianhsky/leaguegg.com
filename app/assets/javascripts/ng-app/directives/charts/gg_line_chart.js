angular.module('leaguegg.partials').directive('ggLineChart', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/partials/charts/gg_line_chart.html',
    scope: {
      'timeline': '=',
      'name': '@'
    },
    controller: ['$scope',
      function($scope) {

        $scope.$watch('timeline', function(newVal, oldVal) {
          $scope.labels = $scope.getLabels();
          $scope.data = $scope.getData();
          $scope.series = $scope.getSeries();
        });

        $scope.getData = function() {
          if ($scope.timeline) {
            return [$scope.timeline];
          }
          return [];
        }

        $scope.getLabels = function() {
          return ['10m', '20m', '30m', 'end'];
        }

        $scope.getSeries = function() {
          return [$scope.name];
        }

      }
    ]
  }
});