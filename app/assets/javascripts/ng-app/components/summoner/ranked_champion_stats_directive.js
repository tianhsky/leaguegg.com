angular.module('leaguegg.summoner').directive('summonerRankedChampionStats', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/summoner/_ranked_champion_stats.html',
    scope: {
      'stats': '=',
      'season': '='
    },
    controller: ['$scope', '$postscribe',
      function($scope, $postscribe) {
        // $(function(){
        //   var adElemId = "#ad-summoner-champion-stat-footer";
        //   var adUrl = "//go.padstm.com/?id=456348";
        //   postscribe(adElemId, '<script src="' + adUrl + '"><\/script>');
        // });
      }
    ]
  }
});