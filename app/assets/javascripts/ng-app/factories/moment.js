angular.module('utils').factory('$moment', ['$window',
  function($window) {
    return $window.moment;
  }
]);
