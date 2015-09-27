angular.module('GameModule').directive('featuredGames', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/game/featured/index.html',
    scope: {},
    controller: ['$scope', 'FeaturedGamesService',
      function($scope, FeaturedGamesService) {
        $scope.featured_games = null;
        $scope.rotate_interval = 5000;
        $scope.no_wrap_slide = false;

        FeaturedGamesService.getFeaturedGames()
          .then(function(resp) {
            $scope.featured_games = resp.featured_games;
          });
      }
    ]
  }
});