angular.module('leaguegg.game').service('FeaturedGamesService', [
  '$http', '_',
  function($http, _) {
    var self = this;

    self.getFeaturedGames = function() {
      var url = "/api/featured.json";
      return $http.get(url)
        .then(function(resp) {
          var data = resp.data;
          _.each(data.featured_games, function(g) {
            g.url = self.findUrlForGame(g);
          });
          return data;
        }, function(err) {
          return err;
        });
    }

    self.findUrlForGame = function(game) {
      var region = 'na';
      var summoner = game.teams[0].participants[0].summoner.name;
      var url = '/game/' + region + '/' + summoner;
      return url;
    }

  }
]);