angular.module('leaguegg.searchbar').directive('searchbar', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/searchbar/index.html',
    scope: {},
    controller: ['$scope', '$location', 'ConstsService', 'SearchbarService',
      function($scope, $location, ConstsService, SearchbarService) {
        $scope.platforms = ConstsService.regions;
        $scope.query = SearchbarService.getSearchQuery();
        $scope.result = SearchbarService.getSearchResult();

        $scope.submitSearch = function() {
          var searchUrl = SearchbarService.getSearchUrl();
          if (searchUrl) {
            $location.path(searchUrl);
          }
        }

      }

    ]
  }
});