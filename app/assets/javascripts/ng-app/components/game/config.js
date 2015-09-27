angular.module('GameModule').config([
  '$stateProvider', '$urlRouterProvider',
  function($stateProvider, $urlRouterProvider) {
    $stateProvider
      .state('index.game', {
        url: "/game/:region/:summoner",
        templateUrl: "static/game/live/index.html",
        controller: 'LiveGameCtrl'
      });
  }
]);