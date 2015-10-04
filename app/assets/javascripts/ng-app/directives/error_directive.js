angular.module('leaguegg.partials').directive('error', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/partials/error.html',
    scope: {
      error: '='
    }
  }
});
