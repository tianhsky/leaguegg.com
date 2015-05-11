app = angular.module('app', [
  'ngAnimate',
  'ui.router',
  'truncate',
  'templates'
]).config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
  function($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider
      .state('game', {
        url: '/',
        templateUrl: 'game/show.html',
        controller: 'GameCtrl'
      });
    $urlRouterProvider.otherwise('/');
    $locationProvider.html5Mode(true);
  }
]);