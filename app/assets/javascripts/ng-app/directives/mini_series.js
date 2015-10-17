angular.module('leaguegg.partials').directive('miniSeries', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/partials/mini_series.html',
    scope: {
      sequence: '='
    },
    controller: ['$scope',
      function($scope) {
        if ($scope.sequence) {
          $scope.sequence_array = $scope.sequence.split('');
        }
      }
    ]
  }
});