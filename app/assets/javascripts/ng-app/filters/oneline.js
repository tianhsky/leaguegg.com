angular.module('utils').filter('oneline', function() {
  return function(text) {
    if (text !== undefined) return text.replace(/ /g, '\u00a0');
  };
});