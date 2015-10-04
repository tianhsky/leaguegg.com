angular.module('leaguegg').config([
  '$locationProvider', '$urlRouterProvider', '$stateProvider',
  function($locationProvider, $urlRouterProvider, $stateProvider) {
    $locationProvider.html5Mode(true);
    $urlRouterProvider.otherwise("/404");

    $stateProvider.state('index', {
        url: '',
        views: {
          '@': {
            templateUrl: 'static/layout/application.html',
            controller: 'LayoutCtrl'
          },
          'header@index': {
            templateUrl: 'static/layout/header.html',
          },
          'footer@index': {
            templateUrl: 'static/layout/footer.html',
          },
          'body@index': {
            templateUrl: 'static/layout/body.html',
          },
        },
      })
      .state('index.404', {
        url: '/404',
        templateUrl: "static/home/404.html"
      });

  }
]);