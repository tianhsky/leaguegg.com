$(function() {

  var checkBrowser = function() {
    if (bowser.msie) {
      var version = parseInt(bowser.version);
      if (version <= 9) {
        $('#page').empty();
        $('#error-browser-not-support').show();
        var query = location.search;
        location.href = "/browser_error.html"+query;
      }
    }
  }
  checkBrowser();
})