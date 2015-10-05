angular.module('utils').factory('$md5', ['$window',
  function($window) {
    return $window.md5;
  }
]);
