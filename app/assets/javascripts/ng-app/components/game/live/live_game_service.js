angular.module('leaguegg.game').service('LiveGameService', [
  '$localStorage', '_', '$http', '$q', 'Analytics', 'OPGG', '$sce',
  function($localStorage, _, $http, $q, Analytics, OPGG, $sce) {
    var self = this;

    self.SetCacheQuery = function(query) {
      $localStorage.setObject('searchgame', query);
    }

    self.getCacheQuery = function() {
      return $localStorage.getObject('searchgame');
    }

    self.clearCacheQuery = function() {
      $localStorage.remove('searchgame');
    }

    self.getSearchQuery = function() {
      var query = self.getCacheQuery();
      if (_.isEmpty(query)) {
        query = {
          region: 'NA',
          summoner: null
        }
      }
      return query;
    }

    self.getSearchUrl = function(type, query) {
      var url = null;
      if (!_.isEmpty(query.region) && !_.isEmpty(query.summoner)) {
        if (type == 'json') {
          url = '/api/game.json?summoner_name=' + query.summoner + '&region=' + query.region;
        } else if (type == 'html') {
          url = "/game/" + query.region + "/" + query.summoner;
        }
      }
      return url;
    }

    self.getGameBySummoner = function(query) {
      Analytics.trackEvent('Game', 'SearchByRegion', query.region, 1);
      Analytics.trackEvent('Game', 'SearchBySummoner', query.summoner + "@" + query.region, 1);
      var url = self.getSearchUrl('json', query);
      return $q(function(resolve, reject) {
        $http.get(url)
          .then(function(resp) {
            resolve(resp.data);
          }, function(err) {
            reject(err);
          });
      });
    }

    self.applyOPGGUrl = function(game) {
      var region = game.region;
      _.each(game.teams, function(team) {
        _.each(team.participants, function(p) {
          p.opgg_summoner_url = OPGG.getOPGGUrl(region, p.summoner.name);
        });
      });
    }

    self.groupMasteries = function(masteries) {
      var grouped = _.groupBy(masteries, function(m) {
        return m.category;
      });
      var offenses = _.reduce(grouped['Offense'],function(memo,o){return memo+o.rank},0);
      var defenses = _.reduce(grouped['Defense'],function(memo,o){return memo+o.rank},0);
      var utilities = _.reduce(grouped['Utility'],function(memo,o){return memo+o.rank},0);
      var result = {
        offense: offenses,
        defense: defenses,
        utility: utilities
      };
      return result;
    }

    self.applyGroupMasteries = function(game) {
      _.each(game.teams, function(team) {
        _.each(team.participants, function(p) {
          p.masteries_grouped = self.groupMasteries(p.masteries);
          var tooltip_html = "<div>Offense: " + p.masteries_grouped.offense + "</div>";
          tooltip_html += "<div>Defense: " + p.masteries_grouped.defense + "</div>";
          tooltip_html += "<div>Utility: " + p.masteries_grouped.utility + "</div>";
          p.masteries_tooltip_html = $sce.trustAsHtml(tooltip_html);
        });
      });
    }

    self.applyRunesTooltip = function(game) {
      _.each(game.teams, function(team) {
        _.each(team.participants, function(p) {
          var tooltip_html = "";
          _.each(p.runes, function(r) {
            tooltip_html += "<div style='text-align:left;'>" + r.count + " x " + r.description + "" + "</div>";
          });
          p.runes_tooltip_html = $sce.trustAsHtml(tooltip_html);
        });
      });
    }
  }
]);