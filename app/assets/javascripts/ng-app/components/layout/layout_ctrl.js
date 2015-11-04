angular.module('leaguegg.layouts').controller('LayoutCtrl', [
  '$scope', '$rootScope',
  function($scope, $rootScope) {
    
    $scope.fatHeader = true;
    var unbindWatcher = $rootScope.$watch('layoutProperties', function(newVal, oldVal) {
      $scope.fatHeader = newVal.fatHeader;
    }, true);
    $scope.$on('$destroy', function() {
      unbindWatcher();
    });

  }
]);