angular.module('leaguegg.partials').directive('ggRadarChart', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/partials/charts/gg_radar_chart.html',
    scope: {
      '_labels': '=',
      '_data': '=',
      'playerRoles': '='
    },
    controller: ['$scope', '_',
      function($scope, _) {

      }
    ]
  }
});