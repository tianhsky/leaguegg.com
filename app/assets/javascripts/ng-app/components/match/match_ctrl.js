angular.module('leaguegg.match').controller('MatchCtrl', [
  '$scope', '$stateParams', '$filter', 'LayoutService',
  'MatchService', 'ConstsService', 'MetaService', 'Analytics',
  function($scope, $stateParams, $filter, LayoutService,
    MatchService, ConstsService, MetaService, Analytics) {
    alert(1);
    LayoutService.setFatHeader(false);
    MetaService.setTitle($stateParams.region + ' - Match - League of Legends');

    // $scope.data = {
    //   summoner: null,
    //   summoner_stats: null,
    //   season: $filter('titleize')(ConstsService.season),
    //   error: {
    //     summoner: null,
    //     summoner_stats: null
    //   },
    //   loading: {
    //     summoner: {
    //       active: true,
    //       text: 'Loading summoner ...',
    //       theme: 'taichi'
    //     },
    //     summoner_stats: {
    //       active: true,
    //       text: 'Loading summoner stats ...',
    //       theme: 'taichi'
    //     }
    //   }
    // }

    $scope.$on('$destroy', function() {
      MetaService.useDefault();
    });
  }
]);