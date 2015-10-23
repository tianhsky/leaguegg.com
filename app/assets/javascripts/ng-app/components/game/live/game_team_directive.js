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
          Analytics.trackEvent('Summoner', 'SearchFromGame', summoner.name + '@' + summoner.region, 1);
        }

        $scope.championClicked = function(summoner, champion) {
          Analytics.trackEvent('SummonerChampion', 'SearchFromGame', summoner.name + '@' + summoner.region + '-' + champion.name, 1);
        }
      }
    ]
  }
});