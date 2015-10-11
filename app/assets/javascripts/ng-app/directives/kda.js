angular.module('leaguegg.partials').directive('kda', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/partials/kda.html',
    scope: {
      rate: '=',
      k: '=',
      d: '=',
      a: '=',
      k_diff: '=',
      d_diff: '=',
      a_diff: '='
    }
  }
});
