angular.module('leaguegg.feedback').service('FeedbackService', [
  '$localStorage', '_', '$http', '$q', 'Analytics',
  function($localStorage, _, $http, $q, Analytics) {
    var self = this;

    self.getFeedbacks = function(query) {
      var url = "/api/feedbacks.json";
      return $q(function(resolve, reject) {
        $http.get(url)
          .then(function(resp) {
            resolve(resp.data);
          }, function(err) {
            reject(err);
          });
      });
    }

  }
]);