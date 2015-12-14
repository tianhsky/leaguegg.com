angular.module('leaguegg.consts').service('ItemService', [
  '$http', '$q',
  function($http, $q) {
    var self = this;
    var _data = {};
    var _json_url = "http://ddragon.leagueoflegends.com/cdn/5.24.1/data/en_US/item.json";
    var _img_url = "http://ddragon.leagueoflegends.com/cdn/5.24.1/img/item/";

    self.getItemImgUrlByID = function(id) {
      var img_url = _img_url + id + ".png";
      return img_url;
    }

    self.getItemByID = function(id) {
      return $q(function(resolve, reject) {
        getData().then(function(items) {
          var item = items.data[id];
          item.img_url = _img_url + id + ".png"
          resolve(items.data[id]);
        });
      });
    };

    var fetchData = function() {
      return $q(function(resolve, reject) {
        $http.get(_json_url)
          .then(function(resp) {
            resolve(resp.data);
          }, function(err) {
            reject(err);
          });
      });
    }

    var getData = function() {
      return $q(function(resolve, reject) {
        if (_data.items) {
          resolve(_data.items);
        } else {
          fetchData().then(function() {},
            function(err) {
              reject(err);
            }
          );
        }
      });
    }

  }
]);