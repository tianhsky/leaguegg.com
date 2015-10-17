angular.module('utils').factory('$alexa', ['$window',
  function($window) {
    return $window._alexa;
  }
]);