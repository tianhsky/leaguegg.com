$(function() {
  function Rotation() {
    var champions = $(".free-champions li");
    var wrapper = $(".site-wrapper");
    var champion_name = $(".champion-name");
    var champion_title = $(".champion-title");
    var current = 0;
    var inteval = 5000;
    var timer = null;

    function next() {
      var li = $(champions[current]);
      selectItem(li);
      current++;
      if (current >= champions.length) current = 0;
    }

    function selectItem(li) {
      wrapper.css('background-image', "url(" + li.data('splash') + ")");
      champion_name.text(li.data('name'));
      champion_title.text(li.data('title'));
      champions.removeClass("active");
      li.addClass("active");
    }

    function bindClick() {
      var self = this;
      champions.click(function() {
        stop();
        var li = $(this);
        selectItem(li);
      });
    }

    function stop() {
      if (timer) clearInterval(timer);
    }

    this.start = function() {
      next();
      timer = setInterval(next, inteval);
      bindClick();
    }
  }

  var rotation = new Rotation();
  rotation.start();
})