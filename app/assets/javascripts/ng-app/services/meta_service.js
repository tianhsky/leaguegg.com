angular.module('utils').service('MetaService', [
  'ConstsService',
  function(ConstsService) {
    var self = this;
    var TITLE = ConstsService.site_title;
    var DESCRIPTION = ConstsService.site_description;
    var KEYWORDS = ConstsService.site_keywords;

    self.useDefault = function(){
      self.setTitle(null);
      self.setDescription(null);
      self.setKeywords(null);
    }

    self.setTitle = function(title) {
      var dom = $('title');
      var text = TITLE;
      if (title) {
        text = title;
      }
      dom.text(text);
    }

    self.setDescription = function(description) {
      var dom = $('meta[name=description]');
      var text = DESCRIPTION;
      if (description) {
        text = description;
      }
      dom.attr('content', text);
    }

    self.setKeywords = function(keywords_arr) {
      var dom = $('meta[name=keywords]');
      var arr = KEYWORDS;
      if (keywords_arr) {
        arr.concat(keywords_arr);
      }
      dom.attr('content', arr.join(','));
    }


  }
]);