//templates, ui.router, ngAnimate
//leaguegg
//utils, leaguegg.consts
//leaguegg.home, leaguegg.game, leaguegg.searchbar
//leaguegg.champion, leaguegg.layout

angular.module('utils', [
  'templates', 'ui.router', 'ui.bootstrap',
  'truncate', 'ngAnimate', 'ngInflection',
  'angular-google-analytics', 'chart.js',
  'angular-send-feedback', '720kb.socialshare',
  'animate-change', 'timer'
]);

angular.module('leaguegg.consts', []);

angular.module('leaguegg.partials', []);

angular.module('leaguegg.layouts', [
  'utils'
]);

angular.module('leaguegg.home', [
  'utils'
]);

angular.module('leaguegg.game', [
  'utils'
]);

angular.module('leaguegg.searchbar', [
  'utils'
]);

angular.module('leaguegg.champion', [
  'utils'
]);

angular.module('leaguegg.summoner', [
  'utils'
]);

angular.module('leaguegg.match', [
  'utils'
]);

angular.module('leaguegg', [
  'leaguegg.consts', 'leaguegg.partials',
  'leaguegg.home', 'leaguegg.game', 'leaguegg.searchbar', 'leaguegg.champion',
  'leaguegg.layouts', 'leaguegg.summoner', 'leaguegg.match'
]);