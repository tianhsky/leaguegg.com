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

angular.module('utils').filter('duration', ['$moment', function($moment) {
  return function(input, format) {
    if((typeof(input) == 'undefined') || (input == null)){
      return "";
    }
    if(format == 'sec'){
      var mins = Math.floor(input / 60);
      var secs = input % 60;
      var r = mins + ":" + secs;
      return r;
    }
    return '';
  };
}]);