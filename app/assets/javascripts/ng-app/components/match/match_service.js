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
      var url = '/api/matches/'+match_id+'.json?&region=' + region;
      if (include_timeline) {
        url += '&include_timeline=1';
      }
      return $q(function(resolve, reject) {
        $http.get(url)
          .then(function(resp) {
            var match = resp.data;
            combineParticipantFrameItems(match);
            _data.result.match = match;
            resolve(match);
          }, function(err) {
            reject(err);
          });
      });
    }

    self.getMatchInfo = function(region, match_id, include_timeline) {
      var shouldFetch = false;
      shouldFetch = true;
      if (shouldFetch) {
        return self.fetchMatchInfo(region, match_id, include_timeline);
      } else {
        return $q(function(resolve, reject) {
          resolve(_data.result.match);
        });
      }
    }

    var combineParticipantFrameItems = function(match) {
      _.each(match.timeline.frames, function(f) {
        var pfs = f.participant_frames;
        if (pfs) {
          _.each(pfs, function(pf) {
            if (pf.items) {
              pf.items = _.uniq(pf.items);
            }
          })
        }
      });
    }

  }
]);