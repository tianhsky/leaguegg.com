angular.module('leaguegg.game').controller('LiveGameCtrl', [
  '$scope', '$stateParams', '$location', '$timeout',
  'LiveGameService', '$postscribe',
  'ConstsService', '$filter', 'LayoutService', 'Analytics',
  function($scope, $stateParams, $location, $timeout,
    LiveGameService, $postscribe,
    ConstsService, $filter, LayoutService, Analytics) {
    LayoutService.setFatHeader(false);
    LayoutService.setBGImg('/static/img/bg-sand.png');

    $scope.loading = {
      game: {
        active: true,
        text: 'Searching Game ...',
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
    $scope.timeout_promise = null;

    LiveGameService.getGameBySummoner($scope.query)
      .then(function(resp) {
        $scope.loading.game.active = false;
        $scope.error_summoner_not_in_game = false;
        $scope.game = resp;
        $timeout(function(){
          var adElemId = "#ad-live-game-bottom";
          var adUrl = "//go.padstm.com/?id=456348";
          $postscribe(adElemId, '<script src="' + adUrl + '"><\/script>');
        }, 1000);
      }, function(err) {
        $scope.loading.game.active = false;
        if (err.status == 404) {
          $scope.error = err.data.error;
          if ($scope.error == 'Summoner is not currently in game') {
            $scope.error_summoner_not_in_game = true;
            $scope.timeout_promise = $timeout(function() {
              var url = '/summoner/' + $scope.query.region + '/' + $scope.query.summoner + '/matches';
              $location.path(url);
            }, 3000);
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

    $scope.$on('$destroy', function() {
      $timeout.cancel($scope.timeout_promise);
    })

  }
]);