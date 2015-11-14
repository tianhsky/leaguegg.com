angular.module('leaguegg.feedback').controller('FeedbackCtrl', [
  '$scope', '$stateParams', '$location',
  'FeedbackService', 'LayoutService', 'Analytics',
  function($scope, $stateParams, $location,
    FeedbackService, LayoutService, Analytics) {
    LayoutService.setFatHeader(false);
    LayoutService.setBGImg('/static/img/bg-sand.png');

    $scope.data = {};

    var getData = function() {
      FeedbackService.getFeedbacks()
        .then(function(data) {
          $scope.data.feedbacks = data.feedbacks;
        });
    }

    getData();

  }
]);