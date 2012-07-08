(function() {

  Readings.Tag = (function() {

    function Tag(record) {
      this.href = record.href;
      this.name = record.name;
      this.slug = $.grep(this.href.split('/'), function(e) {
        return e !== "";
      });
    }

    Tag.prototype.render = function() {
      return "<li";
    };

    return Tag;

  })();

  $.fn.Readings.TagList = function(category) {
    return this.each(function() {
      var list;
      list = $(this);
      return $.ajax({
        url: Readings.config.get('wlurl') + ("/api/" + this.category),
        contentType: "json",
        success: function(data) {
          var t, tags, _i, _len, _results;
          console.log(data);
          tags = $.map(data, function(rec) {
            return new Readings.Tag(rec);
          });
          list.empty();
          _results = [];
          for (_i = 0, _len = tags.length; _i < _len; _i++) {
            t = tags[_i];
            _results.push(list.append(t.render()));
          }
          return _results;
        }
      });
    });
  };

  Readings.TagList = (function() {

    TagList.prototype.defaults = null;

    function TagList(list, options) {
      this.options = $.extend(this.defaults, options);
      if (!(list.tag_list != null)) list.tag_list = this;
      list.tag_list;
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
