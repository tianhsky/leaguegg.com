angular.module('leaguegg.partials').directive('roles', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/partials/roles.html',
    scope: {
      roles: '='
    },
    controller: ['$scope', '_',
      function($scope, _) {
        var roles = _.sortBy($scope.roles, function(r){
          return -r.games;
        })
        var primary_role = roles[0];
        $scope.main_role = primary_role;
      }
    ]
  }
});