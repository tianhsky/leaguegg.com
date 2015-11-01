angular.module('leaguegg.game').directive('featuredGames', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/game/featured/index.html',
    scope: {},
    controller: ['$scope', '$interval', '_',
      'FeaturedGamesService', '$location', 'Analytics',
      function($scope, $interval, _, FeaturedGamesService,
        $location, Analytics) {
        var interval = null;
        $scope.featured_games = null;
        $scope.loading = {
          featured: {
            active: true,
            text: null,
            theme: 'default'
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

          var nextGame = $scope.featured_games[nextID];
          $scope.selectGame(nextGame);
        }

        FeaturedGamesService.getFeaturedGames()
          .then(function(resp) {
            $scope.loading.featured.active = false;
            $scope.featured_games = resp.featured_games;
            selectNextGame();
            interval = $interval(selectNextGame, 5000);
          });

        $scope.selectGame = function(game) {
          // deselect
          for (var i = 0; i < $scope.featured_games.length; i++) {
            var g = $scope.featured_games[i];
            if (g != game) {
              g.active = false;
            }
          }

          // select
          game.active = true;
        }

        $scope.goToGame = function(game) {
          var query = game.query;
          var url = FeaturedGamesService.findUrlForGame(query);
          $location.path(url).search({
            featured: 1
          });
          Analytics.trackEvent('FeaturedGame', 'SearchBySummoner', query.summoner + '@' + query.region, 1);
        }

        $scope.$on('$destroy', function() {
          $interval.cancel(interval);
        });
      }
    ]
  }
});