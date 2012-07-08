(function() {

  Readings.category_list = function(list) {
    var cat, labelname, _ref;
    list.empty();
    _ref = Readings.config.get('categories');
    for (cat in _ref) {
      labelname = _ref[cat];
      list.append("<li><a href=\"#page-tags?category=" + cat + "\">" + labelname + "</a></li>");
    }
    return list.listview('refresh');
  };

}).call(this);
