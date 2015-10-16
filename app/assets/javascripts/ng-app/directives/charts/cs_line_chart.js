angular.module('leaguegg.partials').directive('csLineChart', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/partials/charts/gg_line_chart.html',
    scope: {
      'timeline': '=',
      'name': '='
    },
    controller: ['$scope', '_',
      function($scope, _) {

        var getData = function(){
          var timeline = $scope.timeline;
          // var m10 = timeline.zero_to_ten;
          // var m20 = timeline.ten_to_twenty;
          // var m30 = timeline.twenty_to_thirty;
          // var mend = timeline.thirty_to_end;
          // var data = [[m10, m20, m30, mend]];
          return data;
        }

        var getLabels = function(){
          return ['10m', '20m', '30m', 'end']
        }

        $scope.labels = getLabels();
        $scope.data = getData();
        $scope.series = ['CS'];
      }
    ]
  }
});