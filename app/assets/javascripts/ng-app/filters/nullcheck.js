angular.module('utils').filter('nullcheck', function() {
  return function(input, sym) {
    var output = "";
    if (typeof(input) == "undefined" || input == null){
      if(typeof(sym) == "undefined" || sym == null){
        output = "-";
      }
      else{
        output = sym;
      }
    }
    else{
      output = input;
    }

    return output;
  };
});