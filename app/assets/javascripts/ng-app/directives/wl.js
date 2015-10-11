angular.module('leaguegg.partials').directive('wl', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/partials/wl.html',
    scope: {
      w: '=',
      l: '=',
      rate: '='
    }
  }
});
