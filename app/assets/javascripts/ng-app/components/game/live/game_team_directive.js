angular.module('leaguegg.game').directive('gameTeam', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/game/live/team.html',
    scope: {
      region: '=',
      season: '=',
      team: '='
    },
    controller: ['$scope', 'Analytics',
      function($scope, Analytics) {
        $scope.summonerClicked = function(summoner) {
          Analytics.trackEvent('Game', 'Summoner', 'Click', 1);
        }

        $scope.championClicked = function(summoner, champion) {
          Analytics.trackEvent('Game', 'SummonerChampion', 'Click', 1);
        }

        $scope.csHovered = function(){
          Analytics.trackEvent('Game', 'CS', 'Hover', 1);
        }

      }
    ]
  }
});