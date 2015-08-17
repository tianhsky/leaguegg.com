$(function(){
  function showSearchError(){
    $(".search-message").addClass("hidden");
    $(".search-error").removeClass("hidden");
  }
  if(window.data && window.data.search){
    var search = window.data.search;
    var url = "/"+search.type+"/"+search.region+"/"+search.summoner;
    $.ajax({
      method: "GET",
      url: url,
      success: function(res){
        location.href = url;
      },
      error: function(err){
        showSearchError();
      }
    });
  }
});