$(function() {

  var checkBrowser = function() {
    var brand = bowser.name;
    if (brand.msie) {
      var version = parseInt(bowser.version);
      if (version <= 9) {
        $('#page').empty();
        $('#error-browser-not-support').show();
      }
    }
  }
  checkBrowser();
})