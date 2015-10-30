angular.module('leaguegg.match').controller('MatchCtrl', [
  '$scope', '$stateParams', '$filter', '$interval', 'LayoutService',
  'MatchService', 'ConstsService', 'MetaService', 'Analytics',
  function($scope, $stateParams, $filter, $interval, LayoutService,
    MatchService, ConstsService, MetaService, Analytics) {
    LayoutService.setFatHeader(false);
    MetaService.setTitle('Match - League of Legends');

    $scope.data = {
      match: null,
      current_frame: 0,
      player_status: 'stopped',
      error: {
        match: null
      },
      loading: {
        match: {
          active: true,
          text: 'Loading match ...',
          theme: 'taichi'
        }
      }
    }

    var loadMatch = function() {
      $scope.data.loading.match.active = false;
      MatchService.getMatchInfo($stateParams.region, $stateParams.match_id, true)
        .then(function(data) {
          $scope.data.match = data;
          $scope.data.loading.match.active = false;
          $scope.play();
        }, function(err) {
          $scope.data.loading.match.active = false;
          $scope.data.error.match = err;
        });

      $scope.$on('$destroy', function() {
        MetaService.useDefault();
      });
    }

    loadMatch();

    var _playInteval = null;
    var perFrame = 300;
    $scope.play = function(){
      if(!_playInteval){
        _playInteval = $interval(function(){
          var totalFrames = $scope.data.match.timeline.frames.length;
          if($scope.data.current_frame < totalFrames-1){
            $scope.data.current_frame += 1;
          }
          else{
            $scope.pause();
          }
        }, perFrame);
      }
      $scope.data.player_status = 'playing';
    }

    $scope.pause = function(){
      $interval.cancel(_playInteval);
      _playInteval = null;
      $scope.data.player_status = 'paused';
    }

    $scope.stop = function(){
      $scope.pause();
      $scope.data.current_frame = 0;
      $scope.data.player_status = 'stopped';
    }

  }
]);