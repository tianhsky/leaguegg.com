angular.module('leaguegg.consts').service('ConstsService', [
  '$window',
  function($window) {
    var _data = {};
    var platforms = ["na", "euw", "eune", "br", "tr", "ru", "lan", "las", "oce", "kr"];
    _data.platforms = _.map(platforms, function(i) {
      return i.toUpperCase()
    });

    _data.season = $window.SEASON;
    return _data;
  }
]);