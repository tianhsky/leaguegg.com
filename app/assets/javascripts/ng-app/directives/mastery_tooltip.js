angular.module('leaguegg.partials').directive('masteryTooltip', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/partials/mastery_tooltip.html',
    scope: {
      masteries: '='
    },
    controller: [
      '$scope', '_',
      function($scope, _) {

        var groupMasteries = function(masteries) {
          var grouped = _.groupBy(masteries, function(m) {
            return m.category;
          });
          var offenses = _.reduce(grouped['Offense'], function(memo, o) {
            return memo + o.rank
          }, 0);
          var defenses = _.reduce(grouped['Defense'], function(memo, o) {
            return memo + o.rank
          }, 0);
          var utilities = _.reduce(grouped['Utility'], function(memo, o) {
            return memo + o.rank
          }, 0);
          var result = {
            offense: offenses,
            defense: defenses,
            utility: utilities
          };
          return result;
        }

        var genMasteries = function() {
          var masteries_grouped = groupMasteries($scope.masteries);
          return masteries_grouped;
        }

        $scope.data = genMasteries();
      }
    ]
  }
});