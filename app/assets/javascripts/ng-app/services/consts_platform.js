angular.module('leaguegg.consts').service('ConstsPlatform', function(){
  var _data = {};
  var platforms = ["na", "euw", "eune", "br", "tr", "ru", "lan", "las", "oce", "kr"];
  _data.platforms = _.map(platforms, function(i){return i.toUpperCase()});
  return _data;
});
