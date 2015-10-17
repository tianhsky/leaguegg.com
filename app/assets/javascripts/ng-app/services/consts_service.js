angular.module('leaguegg.consts').service('ConstsService', [
  '$window',
  function($window) {
    var _data = {};
    var consts = $window.CONSTS;
    var regions = consts.REGIONS;
    _data.regions = _.map(regions, function(i) {
      return i.toUpperCase()
    });

    _data.season = consts.SEASON;
    _data.site_title = consts.SITE_TITLE;
    _data.site_description = consts.SITE_DESCRIPTION;
    _data.site_keywords = consts.SITE_KEYWORDS;

    return _data;
  }
]);