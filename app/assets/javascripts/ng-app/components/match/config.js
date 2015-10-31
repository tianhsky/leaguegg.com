angular.module('leaguegg.match').config([
  '$stateProvider', '$urlRouterProvider',
  function($stateProvider, $urlRouterProvider) {
    $stateProvider.state('index.match_show', {
      url: "/summoner/:region/:summoner/matches/:match_id",
      templateUrl: "static/match/show.html",
      controller: 'MatchCtrl'
    });
  }
]);