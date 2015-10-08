angular.module('leaguegg.game').directive('liveGameSearch', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/game/live/search.html',
    scope: {},
    controller: [
      '$scope', '$location', 'ConstsService', 'LiveGameService',
      function($scope, $location, ConstsService, LiveGameService) {
        $scope.platforms = ConstsService.platforms;
        $scope.query = LiveGameService.getSearchQuery();

        $scope.submitSearch = function() {
          LiveGameService.SetCacheQuery($scope.query);
          var searchUrl = LiveGameService.getSearchUrl('html', $scope.query);
          if (searchUrl) {
            $location.path(searchUrl);
          }
        }

      }
    ]
  }
});