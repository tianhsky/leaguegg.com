angular.module('leaguegg.match').config([
  '$stateProvider', '$urlRouterProvider',
  function($stateProvider, $urlRouterProvider) {
    $stateProvider.state('index.match_show', {
      url: "/match/:region/:match_id",
      templateUrl: "static/match/show.html",
      controller: 'MatchCtrl'
    });
  }
]);