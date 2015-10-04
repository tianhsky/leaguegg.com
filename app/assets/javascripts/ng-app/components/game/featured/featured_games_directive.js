angular.module('leaguegg.game').directive('featuredGames', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/game/featured/index.html',
    scope: {},
    controller: ['$scope', 'FeaturedGamesService',
      function($scope, FeaturedGamesService) {
        $scope.featured_games = null;
        $scope.rotate_interval = 5000;
        $scope.no_wrap_slide = false;
        $scope.loading = {
          featured: {
            active: true,
            text: null,
            theme: 'taichi'
          }
        };

        FeaturedGamesService.getFeaturedGames()
          .then(function(resp) {
            $scope.loading.featured.active = false;
            $scope.featured_games = resp.featured_games;
          }).then(function(err) {
            $scope.loading.featured.active = false;
          });
      }
    ]
  }
});