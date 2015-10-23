angular.module('leaguegg').config([
  '$locationProvider', '$urlRouterProvider',
  '$stateProvider', '$httpProvider', 'AnalyticsProvider',
  function($locationProvider, $urlRouterProvider,
    $stateProvider, $httpProvider, AnalyticsProvider) {
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
          }
        },
      })
      .state('index.404', {
        url: '/404',
        templateUrl: "static/home/404.html"
      });


    // Server Version Check
    $httpProvider.interceptors.push('$serverVersionInjector');

    // Auth
    $httpProvider.interceptors.push('$authInjector');

    // GA
    AnalyticsProvider.setAccount('UA-61898295-2');
    AnalyticsProvider.trackUrlParams(true);
    AnalyticsProvider.setPageEvent('$stateChangeSuccess');

  }
]);

angular.module('leaguegg').run([
  '$urijs', '$alexa', '$rootScope', 'Analytics',
  function($urijs, $alexa, $rootScope, Analytics) {
    Chart.defaults.global.colours = ["#46BFBD", "#F7464A", "#DCDCDC", "#949FB1", "#FDB45C", "#97BBCD", "#4D5360"];
    $rootScope.$on("$locationChangeSuccess", function(event, next, current) {
      // path
      var uri = $urijs(next);
      var query = uri.query();

      // Alexa
      $alexa.track();

      // TB
      if (query.indexOf('tb=') != -1) {
        var path = uri.path();
        Analytics.trackEvent('TB', 'Click', path, 1);
      }
    });
  }
]);