angular.module('leaguegg.summoner').config([
  '$stateProvider', '$urlRouterProvider',
  function($stateProvider, $urlRouterProvider) {
    $stateProvider.state('index.summoner_show', {
        url: "/summoner/:region/:summoner",
        templateUrl: "static/summoner/show.html",
        controller: 'SummonerCtrl'
      })
      .state('index.summoner_stats_champion', {
        url: "/summoner/:region/:summoner/champion/:champion",
        templateUrl: "static/summoner/ranked_champion.html",
        controller: 'SummonerChampionStatsCtrl'
      })
      .state('index.summoner_match_history', {
        url: "/summoner/:region/:summoner/matches/",
        templateUrl: "static/summoner/match_history.html",
        controller: 'SummonerMatchHistoryCtrl'
      });
  }
]);