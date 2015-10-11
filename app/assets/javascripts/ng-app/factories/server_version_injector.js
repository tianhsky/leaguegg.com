angular.module('utils').factory('$serverVersionInjector', [
  '$window',
  function($window) {
    var injector = {
      response: function(data) {
        var headers = data.headers();
        var serverVersion = (headers['server-version']);
        if(serverVersion){
          if(serverVersion != $window['SERVERVERSION']){
            $window.location.reload();
          }
        }
        return data;
      }
    };
    return injector;
  }
]);