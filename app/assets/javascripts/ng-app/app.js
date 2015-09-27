//leaguegg
//templates, ui.router, ngAnimate, UtilModule, ConstsModule
//HomeModule, GameModule, SearchbarModule, 

angular.module('UtilModule', []);

angular.module('ConstsModule', []);

angular.module('PartialModule', []);

angular.module('HomeModule', [
  'templates', 'ui.router', 'truncate', 'UtilModule'
]);

angular.module('GameModule', [
  'templates', 'ui.router', 'ui.bootstrap', 'truncate', 'UtilModule', 'ConstsModule'
]);

angular.module('SearchbarModule', [
  'templates', 'ui.router', 'truncate', 'UtilModule', 'ConstsModule'
]);

angular.module('leaguegg', [
  'HomeModule', 'GameModule', 'SearchbarModule'
]);
