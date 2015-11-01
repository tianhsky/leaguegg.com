angular.module('leaguegg.summoner').service('SummonerService', [
  '$http', '$q', '_', 'Analytics', 'ConstsService',
  function($http, $q, _, Analytics, ConstsService) {
    var self = this;

    var _data = {};

    var resetData = function() {
      _data = {
        query: {
          summoner: null,
          region: null
        },
        result: {
          summoner: null,
          season_stats: null,
          champion_stats: null,
          match_history: null
        }
      };
    }
    resetData();

    var isQueryChanged = function(region, summoner_name) {
      return region != _data.query.region || summoner_name != _data.query.summoner
    }

    self.getQuery = function() {
      return _data.query;
    }

    self.setQuery = function(region, summoner_name) {
      var changed = (region != _data.query.region) || (summoner_name != _data.query.summoner);
      if (changed) {
        resetData();
      }
      _data.query.region = region;
      _data.query.summoner = summoner_name;
    }

    self.fetchSummonerInfo = function(region, summoner_name, reload_if_outdated) {
      self.setQuery(region, summoner_name);
      _data.result.season_stats = null;
      Analytics.trackEvent('Summoner', 'SearchInfo', summoner_name + '@' + region, 1);
      var url = '/api/summoner.json?summoner_id_or_name=' + summoner_name + '&region=' + region;
      if (reload_if_outdated) {
        url += '&reload=1';
      }
      return $q(function(resolve, reject) {
        $http.get(url)
          .then(function(resp) {
            var summoner = resp.data;
            // self.generateMetaDescription(summoner);
            _data.result.summoner = summoner;
            resolve(summoner);
          }, function(err) {
            reject(err);
          });
      });
    }

    self.getSummonerInfo = function(region, summoner_name, reload_if_outdated) {
      var shouldFetch = false;
      // if (reload_if_outdated) {
      //   shouldFetch = true;
      // } else {
      if (isQueryChanged(region, summoner_name)) {
        shouldFetch = true;
      } else {
        shouldFetch = _data.result.summoner ? false : true;
      }
      // }

      // shouldFetch = _data.result.summoner ? false : true;
      if (shouldFetch) {
        return self.fetchSummonerInfo(region, summoner_name, reload_if_outdated);
      } else {
        return $q(function(resolve, reject) {
          resolve(_data.result.summoner);
        });
      }
    }

    self.fetchSummonerSeasonStats = function(region, summoner_id, reload_if_outdated) {
      Analytics.trackEvent('Summoner', 'SearchSeasonStats', summoner_id + '@' + region, 1);
      var url = '/api/summoner/stats.json?season_stats=1&summoner_id=' + summoner_id + '&region=' + region;
      if (reload_if_outdated) {
        url += '&reload=1';
      }
      return $q(function(resolve, reject) {
        $http.get(url)
          .then(function(resp) {
            _data.result.season_stats = resp.data;
            resolve(resp.data);
          }, function(err) {
            reject(err);
          });
      });
    }

    self.getSummonerSeasonStats = function(region, summoner_id, reload_if_outdated) {
      var shouldFetch = false;
      // if (reload_if_outdated) {
      //   shouldFetch = true;
      // } else {
      shouldFetch = _data.result.season_stats ? false : true;
      // }
      if (shouldFetch) {
        return self.fetchSummonerSeasonStats(region, summoner_id, reload_if_outdated);
      } else {
        return $q(function(resolve, reject) {
          resolve(_data.result.season_stats);
        });
      }
    }

    self.fetchSummonerChampionStats = function(region, summoner_id, champion_id) {
      var url = '/api/summoner/stats.json?recent_stats=1&summoner_id=' + summoner_id + '&champion_id=' + champion_id + '&region=' + region;
      return $q(function(resolve, reject) {
        $http.get(url)
          .then(function(resp) {
            _data.result.champion_stats = resp.data;
            resolve(resp.data);
          }, function(err) {
            reject(err);
          });
      });
    }

    self.getSummonerMatches = function(region, summoner_name, reload_if_outdated) {
      var shouldFetch = false;
      if (isQueryChanged(region, summoner_name)) {
        shouldFetch = true;
      } else {
        shouldFetch = _data.result.match_history ? false : true;
      }
      // shouldFetch = _data.result.match_history ? false : true;
      if (shouldFetch) {
        return self.fetchSummonerMatches(region, summoner_name, reload_if_outdated);
      } else {
        return $q(function(resolve, reject) {
          resolve(_data.result.match_history);
        });
      }
    }

    self.fetchSummonerMatches = function(region, summoner_name, reload_if_outdated) {
      var url = '/api/summoner/matches.json?summoner_id_or_name=' + summoner_name + '&region=' + region;
      if (reload_if_outdated) {
        url += '&reload=1';
      }
      return $q(function(resolve, reject) {
        $http.get(url)
          .then(function(resp) {
            var d = resp.data.matches;
            self.markCurrentParticipantForMatches(d, _data.result.summoner);
            self.genParticipantUrlForMatches(d);
            _data.result.match_history = d;
            resolve(d);
          }, function(err) {
            reject(err);
          });
      });
    }

    self.markCurrentParticipantForMatches = function(matches, summoner) {
      if (matches) {
        _.each(matches, function(m) {
          _.each(m.teams, function(t) {
            _.each(t.participants, function(p) {
              if (p.summoner.id == summoner.id) {
                m.cp = p;
              }
            });
          });
        });
      }
    }

    self.genParticipantUrlForMatches = function(matches) {
      if (matches) {
        _.each(matches, function(m) {
          _.each(m.teams, function(t) {
            _.each(t.participants, function(p) {
              if (p.summoner && p.summoner.id && p.summoner.name) {
                p.url = "/summoner/" + _data.query.region + "/" + p.summoner.id + "-" + p.summoner.name;
              }
            });
          });
        });
      }
    }

    self.generateMetaDescription = function(summoner) {
      var intro = "";
      var level_info = "";
      var region_info = "";
      var tier_info = "";
      try {
        intro = summoner.name + "'s League of Legends Stats,";
      } catch (err) {}
      try {
        level_info = "Level " + summoner.level + ",";
      } catch (err) {}
      try {
        region_info = "Region " + summoner.region + ",";
      } catch (err) {}

      try {
        if (summoner.league_entries) {
          var e = summoner.league_entries[0];
          if (e) {
            tier_info = e.tier + ' in League ' + e.name;
          }
        }
        if (_.isEmpty(tier_info)) {
          tier_info = "Not in leagues";
        }
      } catch (err) {}
      summoner.meta_description = intro + " " + level_info + " " + region_info + " " + tier_info;
    }

  }
]);