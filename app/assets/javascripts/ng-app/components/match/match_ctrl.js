angular.module('leaguegg.match').controller('MatchCtrl', [
  '$scope', '$stateParams', '$filter', '$interval', 'LayoutService',
  'SummonerService', 'MatchService', 'ConstsService', 'MetaService', 'Analytics',
  function($scope, $stateParams, $filter, $interval, LayoutService,
    SummonerService, MatchService, ConstsService, MetaService, Analytics) {
    LayoutService.setFatHeader(false);
    MetaService.setTitle('Match Replay - League of Legends');

    $scope.data = {
      match: null,
      current_frame: 0,
      player_status: 'stopped',
      error: {
        summoner: null,
        match: null
      },
      loading: {
        summoner: {
          active: true,
          text: null,
          theme: 'default'
        },
        match: {
          active: true,
          text: 'Loading Match Stats...',
          theme: 'default'
        }
      }
    }

    var loadMatch = function() {
      $scope.data.loading.summoner.active = false;
      $scope.data.loading.match.active = true;

      SummonerService.getSummonerInfo($stateParams.region, $stateParams.summoner, true)
        .then(function(summoner) {
          $scope.data.loading.summoner.active = false;
          $scope.data.summoner = summoner;

          MatchService.getMatchInfo($stateParams.region, $stateParams.match_id, true)
            .then(function(match) {
              $scope.data.match = match;
              $scope.data.loading.match.active = false;
              // $scope.play();
            }, function(err) {
              $scope.data.loading.match.active = false;
              $scope.data.error.match = err;
            });

        }, function(err) {
          $scope.data.loading.summoner.active = false;
          $scope.data.error.summoner = err;
        });


      $scope.$on('$destroy', function() {
        MetaService.useDefault();
      });
    }

    loadMatch();

    var _playInteval = null;
    var perFrame = 800;
    $scope.play = function() {
      if (!_playInteval) {
        _playInteval = $interval(function() {
          var totalFrames = $scope.data.match.timeline.frames.length;
          if ($scope.data.current_frame < totalFrames - 1) {
            $scope.data.current_frame += 1;
          } else {
            $scope.pause();
            $scope.data.player_status = 'finished';
          }
        }, perFrame);
      }
      $scope.data.player_status = 'playing';
    }

    $scope.pause = function() {
      $interval.cancel(_playInteval);
      _playInteval = null;
      $scope.data.player_status = 'paused';
    }

    $scope.stop = function() {
      $scope.pause();
      $scope.data.current_frame = 0;
      $scope.data.player_status = 'stopped';
    }

    $scope.$on('$destroy', function() {
      $scope.stop();
    });

  }
]);