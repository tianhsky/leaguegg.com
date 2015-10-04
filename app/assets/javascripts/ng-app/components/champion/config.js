angular.module('leaguegg.champion').config([
  '$stateProvider', '$urlRouterProvider',
  function($stateProvider, $urlRouterProvider) {
    $stateProvider
      .state('index.rotation', {
        url: "/rotation",
        templateUrl: "static/champion/rotation/index.html",
        controller: 'RotationCtrl'
      });
  }
]);