angular.module('leaguegg.game').directive('featuredTeam', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/game/featured/team.html',
    scope: {
      team: '='
    }
  }
});