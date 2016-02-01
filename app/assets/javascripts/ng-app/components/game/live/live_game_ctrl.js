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

    // $timeout(function() {
    //   var adElemId = "#ad-live-game-loading";
    //   var adUrl = "//go.padstm.com/?id=456401";
    //   $postscribe(adElemId, '<script src="' + adUrl + '"><\/script>');
    // }, 500);

    LiveGameService.getGameBySummoner($scope.query)
      .then(function(resp) {
        $timeout(function(){
          $scope.loading.game.active = false;
          $scope.error_summoner_not_in_game = false;
          $scope.game = resp;
          // $timeout(function() {
          //   var adElemId = "#ad-live-game-bottom";
          //   var adUrl1 = "//go.padstm.com/?id=461865";
          //   // var adUrl2 = "//go.padstm.com/?id=461873";
          //   // var adUrl3 = "//go.padstm.com/?id=461875";
          //   $postscribe(adElemId+'1', '<script src="' + adUrl1 + '"><\/script>');
          //   // $postscribe(adElemId+'2', '<script src="' + adUrl2 + '"><\/script>');
          //   // $postscribe(adElemId+'3', '<script src="' + adUrl3 + '"><\/script>');
          // }, 1500);
        }, 2000);
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