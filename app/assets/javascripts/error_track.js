window.ErrorTracker = function() {
  var apiHost = "http://errbit.leaguegg.com";
  var apiKey = "714ed19df8a604ac7beab57ec2287ef6";
  var projectID = "leaguegg";
  var tracker = new airbrakeJs.Client({
    projectId: projectID,
    projectKey: apiKey
  });
  tracker._host = apiHost;
  window.onerror = function(message, file, line) {
    tracker.notify({
      error: {
        message: message,
        fileName: file,
        lineNumber: line
      }
    });
  }
}
window.errorTracker = new ErrorTracker();

b();