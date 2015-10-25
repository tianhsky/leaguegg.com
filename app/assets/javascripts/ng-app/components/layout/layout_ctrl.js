angular.module('leaguegg.layouts').controller('LayoutCtrl', [
  '$scope', '$rootScope',
  function($scope, $rootScope) {
    $scope.fatHeader = true;
    $rootScope.$watch('layoutProperties', function(newVal, oldVal) {
      $scope.fatHeader = newVal.fatHeader;
    }, true);

    $scope.feedback_options = {
      html2canvasURL: null,
      ajaxURL: '/api/feedbacks'
    };
  }
]);