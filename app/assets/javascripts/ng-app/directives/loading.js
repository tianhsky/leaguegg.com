angular.module('utils').directive('loading', [
  function() {
    return {
      restrict: 'E',
      templateUrl: 'static/partials/loading.html',
      transclude: true,
      scope: {
        status: '='
      }
    };

  }
]);