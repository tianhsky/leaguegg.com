angular.module('leaguegg.game').directive('featuredGames', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/game/featured/index.html',
    scope: {},
    controller: ['$scope', '$interval', '_', 'FeaturedGamesService',
      function($scope, $interval, _, FeaturedGamesService) {
        var interval = null;
        $scope.featured_games = null;
        $scope.loading = {
          featured: {
            active: true,
            text: null,
            theme: 'taichi'
          }
        };

        var getCurrentSelectedGame = function() {
          var selection = null;
          for (var i = 0; i < $scope.featured_games.length; i++) {
            var g = $scope.featured_games[i];
            if (g.active) {
              selection = {
                game: g,
                index: i
              };
              break;
            }
          }
          return selection;
        }

        var selectNextGame = function() {
          // find current
          var currentSelection = getCurrentSelectedGame();

          // find next
          var nextID = null;
          if (currentSelection) {
            nextID = currentSelection.index;
            if (currentSelection.index >= $scope.featured_games.length - 1) {
              nextID = 0;
            } else {
              nextID += 1;
            }
          } else {
            nextID = 0;
          }

          // deselect
          for (var i = 0; i < $scope.featured_games.length; i++) {
            var g = $scope.featured_games[i];
            if (i != nextID) {
              g.active = false;
            }
          }

          // select
          $scope.featured_games[nextID].active = true;
        }

        FeaturedGamesService.getFeaturedGames()
          .then(function(resp) {
            $scope.loading.featured.active = false;
            $scope.featured_games = resp.featured_games;
            selectNextGame();
            interval = $interval(selectNextGame, 5000);
          }).then(function(err) {
            $scope.loading.featured.active = false;
          });

        $scope.$on('$destroy', function() {
          $interval.cancel(interval);
        });
      }
    ]
  }
});