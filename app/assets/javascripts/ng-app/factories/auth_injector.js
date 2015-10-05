angular.module('utils').factory('$authInjector', [
  '$md5', '$window',
  function($md5, $window) {
    var authInjector = {
      request: function(config) {
        var path = config.url;
        if (path.startsWith('/api')) {
          var salt = $window.WAPS || '';
          var content = salt + ':' + path;
          var token = $md5(content);
          config.headers['at'] = token;
        }
        return config;
      }
    };
    return authInjector;
  }
]);