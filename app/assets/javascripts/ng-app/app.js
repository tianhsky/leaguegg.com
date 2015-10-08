//templates, ui.router, ngAnimate
//leaguegg
//utils, leaguegg.consts
//leaguegg.home, leaguegg.game, leaguegg.searchbar
//leaguegg.champion, leaguegg.layout

angular.module('utils', [
  'templates', 'ui.router', 'ui.bootstrap',
  'truncate', 'ngAnimate', 'ngInflection'
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
  'utils', 'leaguegg.consts', 'leaguegg.partials'
]);

angular.module('leaguegg.searchbar', [
  'utils', 'leaguegg.consts'
]);

angular.module('leaguegg.champion', [
  'utils'
]);

angular.module('leaguegg', [
  'leaguegg.home', 'leaguegg.game', 'leaguegg.searchbar', 'leaguegg.champion',
  'leaguegg.layouts'
]);