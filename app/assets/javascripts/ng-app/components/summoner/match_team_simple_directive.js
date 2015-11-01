angular.module('leaguegg.match').directive('matchTeamSimple', function() {
  return {
    restrict: 'AE',
    templateUrl: 'static/summoner/_match_team_simple.html',
    replace: true,
    scope: {
      'team': '='
    },
    controller: [
      '$scope', '_',
      function($scope, _) {
        
      }
    ]
  }
});