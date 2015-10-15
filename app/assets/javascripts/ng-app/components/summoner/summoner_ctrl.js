angular.module('leaguegg.summoner').controller('SummonerCtrl', [
  '$scope', 'LayoutService',
  function($scope, LayoutService) {
    $scope.timeline = {
      zero_to_ten: 4.2,
      ten_to_twenty: 6.3,
      twenty_to_thirty: 3.5,
      thirty_to_end: 2.2
    }

  }
]);