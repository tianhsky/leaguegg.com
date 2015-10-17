angular.module('leaguegg.partials').directive('ggPieChart', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/partials/charts/gg_pie_chart.html',
    scope: {
      '_labels': '=',
      '_data': '=',
      'playerRoles': '='
    },
    controller: ['$scope', '_',
      function($scope, _) {
        // $scope.$watch('playerRoles', function(newVal, oldVal) {
        //   var roles = newVal;
        // });

        $scope.$watch('_data', function(newVal, oldVal) {
          $scope.labels = $scope.getLabels();
          $scope.data = $scope.getData();
        });

        $scope.getData = function() {
          return $scope._data;
        }

        $scope.getLabels = function() {
          return $scope._labels;
        }

      }
    ]
  }
});