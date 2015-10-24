angular.module('utils').factory('$quantcast', ['$window',
  function($window) {
    $window._qevents = $window._qevents || [];
    var _quantcast = {
      track: function() {
        var as = document.getElementById("quantcast-tracker");
        if (as) {
          as.remove();
        }
        var elem = document.createElement('script');
        elem.id = 'alexa-tracker';
        elem.src = (document.location.protocol == "https:" ? "https://secure" : "http://edge") + ".quantserve.com/quant.js";
        elem.async = true;
        elem.type = "text/javascript";
        var scpt = document.getElementsByTagName('script')[0];
        scpt.parentNode.insertBefore(elem, scpt);
        $window._qevents.push({
          qacct: "p-Gt2Nz4L8M79AF"
        });
      }
    }
    return _quantcast;
  }
]);