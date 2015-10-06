angular.module('leaguegg.champion').controller('RotationCtrl', [
  '$scope', '$rootScope', '$interval', 'RotationService', 'LayoutService',
  function($scope, $rootScope, $interval, RotationService, LayoutService) {
    $scope.champions = null;
    var interval = null;

    RotationService.getWeeklyChampions()
      .then(function(resp) {
        $scope.champions = resp;
        var len = $scope.champions.length;
        var mid = len / 2;
        $scope.list1 = $scope.champions.slice(0, mid);
        $scope.list2 = $scope.champions.slice(mid, len);
        selectNextChampion();
        interval = $interval(selectNextChampion, 5000);
      });

    $scope.selectChampion = function(champion) {
      _.each($scope.champions, function(current) {
        if (champion == current) {
          current.selected = true;
          LayoutService.setBGImg(current.img_splashes);
        } else {
          current.selected = false;
        }
      });
    }

    $scope.getCurrentSelectedChampion = function() {
      var selected = null;
      if ($scope.champions) {
        selected = _.find($scope.champions, function(i) {
          return i.selected == true
        });
      }
      return selected;
    }

    var selectNextChampion = function() {
      if ($scope.champions) {
        var selected = $scope.getCurrentSelectedChampion();
        var nextID = null;
        if (selected) {
          var curID = _.indexOf($scope.champions, selected);
          if (curID != null) {
            nextID = curID;
            nextID += 1;
            if (nextID >= $scope.champions.length) {
              nextID = 0;
            }
          } else {
            nextID = 0;
          }
        } else {
          nextID = 0;
        }
      }
      if (nextID != null) {
        $scope.selectChampion($scope.champions[nextID]);
      }
    }

    $scope.$on('$destroy', function() {
      $interval.cancel(interval);
      LayoutService.setBGImg(null);
    });

  }
]);