angular.module('leaguegg.match').service('MatchService', [
  '$http', '$q', '_', 'Analytics', 'ConstsService',
  function($http, $q, _, Analytics, ConstsService) {
    var self = this;

    var _data = {
      query: {
        match_id: null,
        region: null
      },
      result: {
        match: null
      }
    };

    self.getQuery = function() {
      return _data.query;
    }

    self.fetchMatchInfo = function(region, match_id, include_timeline) {
      _data.query.region = region;
      _data.query.match_id = match_id;
      _data.result.match = null;
      var url = '/api/match.json?match_id=' + match_id + '&region=' + region;
      if (include_timeline) {
        url += '&include_timeline=1';
      }
      return $q(function(resolve, reject) {
        $http.get(url)
          .then(function(resp) {
            var match = resp.data;
            generateMatchTimeline(match);
            _data.result.match = match;
            resolve(match);
          }, function(err) {
            reject(err);
          });
      });
    }

    self.getMatchInfo = function(region, match_id, include_timeline) {
      var shouldFetch = false;
      shouldFetch = _data.result.match ? false : true;
      if (shouldFetch) {
        return self.fetchMatchInfo(region, match_id, include_timeline);
      } else {
        return $q(function(resolve, reject) {
          resolve(_data.result.match);
        });
      }
    }

    var generateMatchTimeline = function(match) {
      
    }

  }
]);