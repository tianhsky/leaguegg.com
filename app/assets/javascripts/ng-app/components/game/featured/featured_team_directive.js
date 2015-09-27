angular.module('GameModule').directive('featuredTeam', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/game/featured/team.html',
    scope: {
      team: '='
    }
  }
});