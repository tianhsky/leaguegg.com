angular.module('leaguegg.champion').controller('RotationCtrl', [
  '$scope', '$rootScope', '$interval', 'RotationService',
  'LayoutService', 'MetaService',
  function($scope, $rootScope, $interval, RotationService,
    LayoutService, MetaService) {
    LayoutService.setFatHeader(true);
    MetaService.setTitle('Free Champions - League of Legends');

    $scope.champions = null;
    var interval = null;

    var setDescription = function() {
      var names = RotationService.getChampionNames($scope.champions);
      var desc = 'Free champions of the week: ' + names.join(', ');
      MetaService.setDescription(desc);
    }

    RotationService.getWeeklyChampions()
      .then(function(resp) {
        $scope.champions = resp;
        setDescription();
        var len = $scope.champions.length;
        var mid = len / 2;
        $scope.list1 = $scope.champions.slice(0, mid);
        $scope.list2 = $scope.champions.slice(mid, len);
        selectNextChampion();
        interval = $interval(selectNextChampion, 4500);
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
      MetaService.useDefault();
    });

  }
]);