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
      '$scope', '_', 'SummonerService',
      function($scope, _, SummonerService) {
        var query = SummonerService.getQuery();
        $scope.match_play_url_prefix = "/summoner/" + query.region + "/" + query.summoner + "/matches/";
      }
    ]
  }
});