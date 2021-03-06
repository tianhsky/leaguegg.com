describe('SearchbarCtrl', function() {

  var $rootScope, $scope, $url, ConstsService, SearchbarService;

  beforeEach(module('leaguegg'));

  beforeEach(inject(function(_$controller_, _$rootScope_, _$url_, _ConstsService_, _SearchbarService_) {
    var $controller = _$controller_;
    $rootScope = _$rootScope_;
    $scope = $rootScope.$new();
    $url = _$url_;
    ConstsService = _ConstsService_;
    SearchbarService = _SearchbarService_;

    controller = $controller('SearchbarCtrl', {
      '$scope': $scope,
      '$url': $url,
      'ConstsService': ConstsService,
      'SearchbarService': SearchbarService
    });
  }));

  it('should go to summoner page when search is clicked', function() {
    spyOn($url, 'go');
    SearchbarService.clearSearchQuery();
    $scope.query.summoner = 'test';
    $scope.query.region = 'NA';
    $scope.submitSearch();
    expect($url.go).toHaveBeenCalled();
  });

});
