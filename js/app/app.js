// Generated by CoffeeScript 1.3.3
(function() {
  var rcategory;

  window.Readings = {};

  $.fn.Readings = function() {
    var a, args, meth, _i, _len;
    meth = arguments[0];
    args = [];
    for (_i = 0, _len = arguments.length; _i < _len; _i++) {
      a = arguments[_i];
      args.push(a);
    }
    args.shift();
    return $.fn.Readings[meth].apply(this, args);
  };

  Readings.init = function() {
    if (Readings.initialized != null) {
      return;
    }
    Readings.config = new Readings.Config({
      wlurl: 'http://readings.local',
      categories: {
        'authors': 'autor',
        'epochs': 'epoka',
        'genres': 'gatunek',
        'kinds': 'rodzaj',
        'themes': 'motyw'
      }
    });
    return Readings.initialized = true;
  };

  $(document).on('pageinit', '#page-categories', function(ev) {
    Readings.init();
    return $('#list-categories').Readings('CategoryList');
  });

  rcategory = /category=(\w+)/;

  $(document).on('pageshow', "#page-tags", function(ev, ui) {
    var category;
    category = rcategory.exec($(this).attr('data-url'));
    if ((category != null) && (category[1] != null)) {
      return $(this).Readings('TagList', category[1]);
    }
  });

}).call(this);
