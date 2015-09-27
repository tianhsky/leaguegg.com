angular.module('GameModule').directive('liveGameSearch', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/game/live/search.html',
    scope: {},
    controller: [
      '$scope', '$location', 'ConstsPlatform', 'LiveGameService',
      function($scope, $location, ConstsPlatform, LiveGameService) {
        $scope.platforms = ConstsPlatform.platforms;
        $scope.query = LiveGameService.getSearchQuery();

        $scope.submitSearch = function() {
          LiveGameService.SetCacheQuery($scope.query);
          LiveGameService.getGameBySummoner($scope.query)
            .then(function(resp) {
              var searchUrl = LiveGameService.getSearchUrl('html', $scope.query);
              if (searchUrl) {
                $location.path(searchUrl);
              }
            })
            .then(function(err) {
              $scope.error = err;
            });
        }

      }
    ]
  }
});