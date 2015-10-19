angular.module('leaguegg.partials').directive('runeTooltip', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/partials/rune_tooltip.html',
    scope: {
      runes: '='
    }
  }
});
