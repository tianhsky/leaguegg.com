angular.module('leaguegg.game').service('FeaturedGamesService', [
  '$http', '_', 'Analytics',
  function($http, _, Analytics) {
    var self = this;

    self.getFeaturedGames = function() {
      Analytics.trackEvent('FeaturedGame', 'SearchByRegion', 'NA', 1);
      var url = "/api/featured.json";
      return $http.get(url)
        .then(function(resp) {
          var data = resp.data;
          _.each(data.featured_games, function(g) {
            g.query = self.findQueryForGame(g);
          });
          return data;
        }, function(err) {
          return err;
        });
    }

    self.findQueryForGame = function(game) {
      var region = game.region;
      var summoner = game.teams[0].participants[0].summoner.name;
      var query = {
        region: region,
        summoner: summoner
      }
      return query;
    }

    self.findUrlForGame = function(query) {
      var url = '/game/' + query.region + '/' + query.summoner;
      return url;
    }

  }
]);