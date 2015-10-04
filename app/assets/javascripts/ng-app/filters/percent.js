angular.module('utils').filter('percentage', ['$filter', function($filter) {
  return function(input, decimals) {
    if((typeof(input) == 'undefined') || (input == null)){
      return "-%";
    }
    return $filter('number')(input * 100, decimals) + '%';
  };
}]);