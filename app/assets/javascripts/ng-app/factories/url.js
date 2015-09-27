angular.module('UtilModule').factory('$url', ['$window',
  function($window) {
    return {
      params: function() {
        var pairs = $window.location.search.slice(1).split('&');
        var result = {};
        pairs.forEach(function(pair) {
          pair = pair.split('=');
          result[pair[0]] = $window.decodeURIComponent(pair[1] || '');
        });
        return result;
      },
      splitPath: function(n) {
        var path = location.pathname;
        var result = null;
        if (n == 1) {
          result = path.match(/\/(.*)/);
        } else if (n == 2) {
          result = path.match(/\/(.*)\/(.*)/);
        } else if (n == 3) {
          result = path.match(/\/(.*)\/(.*)\/(.*)/);
        } else if (n == 4) {
          result = path.match(/\/(.*)\/(.*)\/(.*)\/(.*)/);
        }
        if (result) {
          result = result.splice(1);
        }
        return result;
      },
      go: function(url) {
        $window.location.href = url;
      }
    }
  }
]);