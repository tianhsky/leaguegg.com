angular.module('PartialModule').directive('kda', function() {
  return {
    restrict: 'E',
    templateUrl: 'templates/static/game/_kda.html',
    scope: {
      k: '=k',
      d: '=d',
      a: '=a',
      k_diff: '=k_diff',
      d_diff: '=d_diff',
      a_diff: '=a_diff'
    }
  }
});
