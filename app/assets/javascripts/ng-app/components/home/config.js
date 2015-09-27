angular.module('HomeModule').config([
  '$stateProvider',
  function($stateProvider) {
    $stateProvider
      .state('index.home', {
        url: "/",
        templateUrl: "static/home/index.html",
        controller: 'HomeCtrl'
      });
  }
]);