angular.module('utils').factory('$authInjector', [
  '$md5', '$window',
  function($md5, $window) {
    var authInjector = {
      request: function(config) {
        var path = encodeURI(config.url);
        if (path.indexOf('/api') == 0) {
          var salt = $window['W' + 'A' + 'P' + 'S'] || '';
          var content = salt + ':' + path;
          var token = $md5(content);
          config.headers['a' + 't'] = token;
        }
        return config;
      }
    };
    return authInjector;
  }
]);