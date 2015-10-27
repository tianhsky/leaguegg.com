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

    var sortParticipantsByRole = function(match){
      match.teams[0].participants = _.sortBy(match.teams[0].participants, function(p){ return p.player_role; });
      match.teams[1].participants = _.sortBy(match.teams[1].participants, function(p){ return p.player_role; });
    }

    var generatePerFrameStats = function(match){
      var timeline = match.timeline;
      var frames = timeline.frames;
      _.each(frames, function(f){

      });
    }

    var generateFrameStats = function(){
      var s = {
        kills: 0,
        deaths: 0,
        assists: 0,
        gold_current: 0,
        gold_total: 0,
        xp: 0,
        level: 1,
        cs: 0,
        jcs: 0,
        items: [
        ]
      };
      return s;
    }

    var generateMatchTimeline = function(match) {
      sortParticipantsByRole(match);

    }

  }
]);