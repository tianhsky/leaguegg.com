angular.module('utils').factory('OPGG', [
  function() {
    var _fun = {};
    _fun.getOPGGUrl = function(region, summoner) {
      var url = 'http://' + region + '.op.gg/summoner/userName=' + summoner;
      return url;
    }
    return _fun;
  }
]);
