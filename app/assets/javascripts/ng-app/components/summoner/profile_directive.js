angular.module('leaguegg.summoner').directive('summonerProfile', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/summoner/_profile.html',
    scope: {
      'summoner': '='
    },
    controller: ['$scope', '$postscribe',
      function($scope, $postscribe) {
        $(function(){
          var adElemId = "#ad-summoner-profile-left";
          var adUrl = "//go.padstm.com/?id=456401";
          $postscribe(adElemId, '<script src="' + adUrl + '"><\/script>');
        });
      }
    ]
  }
});