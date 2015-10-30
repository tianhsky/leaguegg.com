angular.module('leaguegg.match').directive('playerTeamSummary', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/match/player_team_summary.html',
    scope: {
      'currentFrame': '=',
      'teamId': '='
    },
    controller: [
      '$scope',
      function($scope) {

        var getData = function() {
          var r = {
            baron_kills: 0,
            dragon_kills: 0,
            building_kills: 0,
            kills: 0,
            deaths: 0,
            assists: 0,
            current_gold: 0,
            total_gold: 0
          };
          if ($scope.currentFrame) {
            r = $scope.currentFrame.team_frames[$scope.teamId];
            var team_participants = _.filter($scope.currentFrame.participant_frames,function(f){
              if($scope.teamId == 100){
                return (f.participant_id <= 5);
              }
              else{
                return (f.participant_id > 5);
              }
            });
            _.each(['kills','deaths','assists','current_gold', 'total_gold'],function(attr){
              r[attr] = _.reduce(team_participants, function(memo, p){ return memo + p[attr]; }, 0)
            });
          }
          return r;
        }

        $scope.$watch('currentFrame', function(nv, ov) {
          $scope.data = getData();
        });


      }
    ]
  }
});