angular.module('leaguegg').config([
  '$locationProvider', '$urlRouterProvider', '$stateProvider',
  function($locationProvider, $urlRouterProvider, $stateProvider) {
    $locationProvider.html5Mode(true);
    $urlRouterProvider.otherwise("/");

    $stateProvider.state('index', {
      url: '',
      views: {
        '@': {
          templateUrl: 'static/layout/application.html'
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
  }
]);