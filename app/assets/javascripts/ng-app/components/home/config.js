angular.module('leaguegg.home').config([
  '$stateProvider',
  function($stateProvider) {
    $stateProvider
      .state('index.home', {
        url: "/",
        templateUrl: "static/home/index.html",
        controller: 'HomeCtrl'
      })
      .state('index.app', {
        url: "/app",
        templateUrl: "static/home/app.html",
        controller: 'AppCtrl'
      });
  }
]);