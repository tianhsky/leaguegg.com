angular.module('utils').filter('number2k', [function() {
  return function(input, decimal) {
    if((typeof(input) == 'undefined') || (input == null)){
      return null;
    }
    var number = parseInt(input);
    if(number >= 1000){
      var k = number / 1000;
      k = k.toFixed(decimal);
      return k + 'K'
    }
    return number;
  };
}]);