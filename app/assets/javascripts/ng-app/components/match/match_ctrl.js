angular.module('leaguegg.summoner').controller('SummonerCtrl', [
  '$scope', '$stateParams', '$filter', 'LayoutService',
  'MatchService', 'ConstsService', 'MetaService', 'Analytics',
  function($scope, $stateParams, $filter, LayoutService,
    MatchService, ConstsService, MetaService, Analytics) {
    LayoutService.setFatHeader(false);
    MetaService.setTitle($stateParams.summoner + ' - ' + $stateParams.region + ' - Summoners - League of Legends');

    $scope.data = {
      summoner: null,
      summoner_stats: null,
      season: $filter('titleize')(ConstsService.season),
      error: {
        summoner: null,
        summoner_stats: null
      },
      loading: {
        summoner: {
          active: true,
          text: 'Loading summoner ...',
          theme: 'taichi'
        },
        summoner_stats: {
          active: true,
          text: 'Loading summoner stats ...',
          theme: 'taichi'
        }
      }
    }

    $scope.$on('$destroy', function() {
      MetaService.useDefault();
    });
  }
]);