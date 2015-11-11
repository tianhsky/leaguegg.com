angular.module('leaguegg.feedback').config([
  '$stateProvider', '$urlRouterProvider',
  function($stateProvider, $urlRouterProvider) {
    $stateProvider
      .state('index.feedback', {
        url: "/feedbacks",
        templateUrl: "static/feedback/index.html",
        controller: 'FeedbackCtrl'
      });
  }
]);