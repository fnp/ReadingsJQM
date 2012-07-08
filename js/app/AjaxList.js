(function() {

  Readings.TagList = (function() {

    TagList.prototype.defaults = null;

    function TagList(list, category, options) {
      this.category = category;
      this.options = $.extend(this.defaults, options);
    }

    TagList.prototype.load = function() {
      return $.ajax({
        url: Readings.config.get('wlurl') + ("/api/" + this.category),
        success: function() {
          return true;
        }
      });
    };

    return TagList;

  })();

}).call(this);
