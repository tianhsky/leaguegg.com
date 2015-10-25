angular.module('leaguegg.partials').directive('feedback', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/partials/feedback.html',
    scope: {},
    controller: ['$scope', '_',
      function($scope, _) {
        $scope.options = {
          html2canvasURL: null,
          initButtonText: 'Feedback',
          ajaxURL: '/api/feedbacks'
        };
      }
    ]
  }
});