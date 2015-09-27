angular.module('SearchbarModule').service('SearchbarService', [
  '$localStorage', '_',
  function($localStorage, _) {
    var self = this;
    var defaultRegion = 'NA';

    var _data = {
      query: {
        summoner: null,
        region: null
      },
      result: {
        status: null,
        message: null
      }
    };

    self.getSearchQuery = function() {
      if (_.isEmpty(_data.query.region) || _.isEmpty(_data.query.summoner)) {
        var cache = $localStorage.getObject('searchbar');
        if (cache) {
          if (_.isEmpty(_data.query.region)) {
            if (!_.isEmpty(cache.region)) {
              _data.query.region = cache.region;
            } else {
              _data.query.region = defaultRegion;
            }
          }
          if (!_.isEmpty(cache.summoner) && _.isEmpty(_data.query.summoner)) {
            _data.query.summoner = cache.summoner;
          }
        }
      }
      return _data.query;
    }

    self.getSearchResult = function() {
      return _data.result;
    }

    self.clearSearchQuery = function() {
      _data.query.summoner = null;
      _data.query.region = null;
      $localStorage.remove('searchbar');
    }

    self.cacheSearchQuery = function() {
      $localStorage.setObject('searchbar', _data.query);
    }

    self.getSearchUrl = function() {
      var url = null;
      if (!_.isEmpty(_data.query.region) && !_.isEmpty(_data.query.summoner)) {
        self.cacheSearchQuery();
        var url = "/summoner/" + _data.query.region + "/" + _data.query.summoner;
      }
      return url;
    }

  }
]);
