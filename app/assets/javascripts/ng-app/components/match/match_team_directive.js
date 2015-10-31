angular.module('leaguegg.match').directive('matchTeam', function() {
  return {
    restrict: 'AE',
    replace: true,
    templateUrl: 'static/match/team.html',
    scope: {
      'team': '=',
      'frame': '='
    },
    controller: [
      '$scope', '$location', 'ItemService',
      function($scope, $location, ItemService) {
        $scope.getItemImgUrlByID = function(id){
          return ItemService.getItemImgUrlByID(id);
        }
      }
    ]
  }
});