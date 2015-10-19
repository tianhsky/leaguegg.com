angular.module('utils').filter('time_from_now', ['$moment', function($moment) {
  return function(input, format) {
    if((typeof(input) == 'undefined') || (input == null)){
      return "";
    }
    if(format == 'unix'){
      var unixTS = parseInt(input);
      return $moment(unixTS).fromNow();
    }
    return '';
  };
}]);