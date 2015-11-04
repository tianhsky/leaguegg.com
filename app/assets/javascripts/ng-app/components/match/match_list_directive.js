angular.module('leaguegg.match').directive('matchList', function() {
  return {
    restrict: 'AE',
    templateUrl: 'static/summoner/_match_list.html',
    replace: true,
    scope: {
      'matches': '=',
      'summoner': '='
    },
    controller: [
      '$scope', '_', 'SummonerService', 'Analytics',
      function($scope, _, SummonerService, Analytics) {

        var query = SummonerService.getQuery();
        $scope.match_play_url_prefix = "/summoner/" + query.region + "/" + query.summoner + "/matches/";

        $scope.matchReplayHovered = function() {
          Analytics.trackEvent('Match', 'Replay', 'Hover', 1);
        }

        $scope.matchReplayClicked = function() {
          Analytics.trackEvent('Match', 'Replay', 'Click', 1);
        }

        $scope.matchDetailHovered = function() {
          Analytics.trackEvent('Match', 'Detail', 'Hover', 1);
        }

        $scope.matchDetailClicked = function(m) {
          m.active = !m.active;
          Analytics.trackEvent('Match', 'Detail', 'Click', 1);
        }

      }
    ]
  }
});