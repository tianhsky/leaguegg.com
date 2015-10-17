_atrk_opts = {
  atrk_acct: "+Ke8m1agbiF2vg",
  domain: "leaguegg.com",
  dynamic: true
};
_alexa = {
  track: function() {
    var as = document.getElementById("alexa-tracker");
    if (as) {
      as.remove();
    }
    var as = document.createElement('script');
    as.id = 'alexa-tracker';
    as.type = 'text/javascript';
    as.async = true;
    as.src = "https://d31qbv1cthcecs.cloudfront.net/atrk.js";
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(as, s);
  }
};
(function() {
  // _alexa.track();
})();