angular.module('leaguegg.match').controller('MatchCtrl', [
  '$scope', '$stateParams', '$filter', 'LayoutService',
  'MatchService', 'ConstsService', 'MetaService', 'Analytics',
  function($scope, $stateParams, $filter, LayoutService,
    MatchService, ConstsService, MetaService, Analytics) {
    LayoutService.setFatHeader(false);
    MetaService.setTitle('Match - League of Legends');

    $scope.data = {
      match: null,
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
        }, function(err) {
          $scope.data.loading.match.active = false;
          $scope.data.error.match = err;
        });

      $scope.$on('$destroy', function() {
        MetaService.useDefault();
      });
    }

    loadMatch();

  }
]);