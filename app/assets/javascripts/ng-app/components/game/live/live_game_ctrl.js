angular.module('leaguegg.game').controller('LiveGameCtrl', [
  '$scope', '$stateParams', '$location', 'LiveGameService',
  'ConstsService', '$filter', 'LayoutService', 'Analytics',
  function($scope, $stateParams, $location, LiveGameService,
    ConstsService, $filter, LayoutService, Analytics) {
    LayoutService.setFatHeader(false);

    $scope.loading = {
      game: {
        active: true,
        text: 'Loading Game ...',
        theme: 'default'
      }
    };
    $scope.query = {
      region: $stateParams.region,
      summoner: $stateParams.summoner
    }
    $scope.season = $filter('titleize')(ConstsService.season);
    $scope.game = null;
    $scope.error = null;

    LiveGameService.getGameBySummoner($scope.query)
      .then(function(resp) {
        $scope.loading.game.active = false;
        $scope.error_summoner_not_in_game = false;
        $scope.game = resp;
      }, function(err) {
        $scope.loading.game.active = false;
        if (err.status == 404) {
          $scope.error = err.data.error;
          if ($scope.error == 'Summoner is not currently in game') {
            $scope.error_summoner_not_in_game = true;
            var url = '/summoner/' + $scope.query.region + '/' + $scope.query.summoner;
            $location.path(url);
          }
        } else {
          $scope.error = "Sorry, there was a problem";
        }
      });

    $scope.matchHistoryAdHovered = function() {
      Analytics.trackEvent('Game', 'ADMatches', 'Hover', 1);
    }

    $scope.matchHistoryAdClicked = function() {
      Analytics.trackEvent('Game', 'ADMatches', 'Click', 1);
    }

  }
]);