angular.module('SearchbarModule').directive('searchbar', function() {
  return {
    restrict: 'E',
    templateUrl: 'static/searchbar/index.html',
    scope: {},
    controller: ['$scope', '$location', 'ConstsPlatform', 'SearchbarService',
      function($scope, $location, ConstsPlatform, SearchbarService) {
        $scope.platforms = ConstsPlatform.platforms;
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