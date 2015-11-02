$(function() {

  var checkBrowser = function() {
    if (bowser.msie) {
      var version = parseInt(bowser.version);
      if (version <= 9) {
        $('#page').empty();
        $('#error-browser-not-support').show();
        location.href = "/browser_error";
      }
    }
  }
  checkBrowser();
})