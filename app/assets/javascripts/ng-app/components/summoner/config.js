angular.module('leaguegg.summoner').config([
  '$stateProvider', '$urlRouterProvider',
  function($stateProvider, $urlRouterProvider) {
    $stateProvider
      .state('index.summoner', {
        url: "/summoner/:region/:summoner",
        templateUrl: "static/summoner/index.html",
        controller: 'SummonerCtrl'
      });
  }
]);