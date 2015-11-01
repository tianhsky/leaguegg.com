angular.module('leaguegg.match').directive('matchTeamDetailSimple', function() {
  return {
    restrict: 'AE',
    templateUrl: 'static/summoner/_match_team_detail_simple.html',
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