$(function(){
  var pieChart = function(ele, data, opts){
    var chartData = data;
    var options = {};
    var chart = new Chart(ele).Pie(chartData,options);
  }

  // kda
  var kdaChartEle = document.getElementById("kda-chart").getContext("2d");
  var kdaChartData = [
    {
      value: window.data.recent_stats.kills,
      color: "#FF6A7A",
      highlight: "#FFA0AA",
      label: "Kills"
    },
    {
      value: window.data.recent_stats.deaths,
      color: "#757575",
      highlight: "#B3B3B3",
      label: "Deaths"
    },
    {
      value: window.data.recent_stats.assists,
      color: "#A28226",
      highlight: "#CAA336",
      label: "Assists"
    }
  ];
  var kdaChart = new pieChart(kdaChartEle, kdaChartData);

  // wl
  var wlChartEle = document.getElementById("wl-chart").getContext("2d");
  var wlChartData = [
    {
      value: window.data.recent_stats.won,
      color: "#5ADA24",
      highlight: "#A9F58A",
      label: "Won"
    },
    {
      value: window.data.recent_stats.lost,
      color: "#D40C0C",
      highlight: "#FF7373",
      label: "Lost"
    }
  ];
  var wlChart = new pieChart(wlChartEle, wlChartData);

})