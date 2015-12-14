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
          var ferocity = _.reduce(grouped['Ferocity'], function(memo, o) {
            return memo + o.rank
          }, 0);
          var cunning = _.reduce(grouped['Cunning'], function(memo, o) {
            return memo + o.rank
          }, 0);
          var resolve = _.reduce(grouped['Resolve'], function(memo, o) {
            return memo + o.rank
          }, 0);

          var result = {
            ferocity: {
              count: ferocity,
              items: grouped['Ferocity']
            },
            cunning: {
              count: cunning,
              items: grouped['Cunning']
            },
            resolve: {
              count: resolve,
              items: grouped['Resolve']
            }
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