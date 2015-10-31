angular.module('leaguegg.match').directive('matchStats', function() {
  return {
    restrict: 'AE',
    templateUrl: 'static/match/stats.html',
    replace: true,
    scope: {
      'match': '='
    },
    controller: [
      '$scope', '_',
      function($scope, _) {
        $scope.$watch('match', function(nv, ov) {
          if (nv) {
            $scope.participants = _.flatten(_.map($scope.match.teams, function(t) {
              return t.participants;
            }));
          }
        })

      }
    ]
  }
});