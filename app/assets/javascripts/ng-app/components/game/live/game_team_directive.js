angular.module('leaguegg.game').directive('gameTeam', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/game/live/team.html',
    scope: {
      team: '='
    }
  }
});