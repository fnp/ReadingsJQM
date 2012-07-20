(function() {
  var rbookid, rcategory, rtag, rtagid;

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
    if (Readings.initialized != null) return;
    Readings.config = new Readings.Config({
      wlurl: 'http://dev.wolnelektury.pl',
      initdburl: 'http://dev.wolnelektury.pl/media/api/mobile/initial/initial.sql',
      categories: {
        'author': 'autor',
        'epoch': 'epoka',
        'genre': 'gatunek',
        'kind': 'rodzaj'
      },
      show_filter: ['authors', 'themes'],
      show_dividers: ['authors', 'themes'],
      db_version: '1.0'
    });
    Readings.catalogue = new Readings.Catalogue().open();
    return Readings.initialized = true;
  };

  $(document).on('pageinit', '#page-categories', function(ev) {
    Readings.init();
    return $('#list-categories').Readings('CategoryList');
  });

  rcategory = /category=(\w+)/;

  rtag = /tag=([a-z0-9-]+)/;

  rtagid = /tag_id=([0-9]+)/;

  rbookid = /book_id=([0-9]+)/;

  $(document).on('pageinit', "#page-tags", function(ev, ui) {
    var category;
    category = rcategory.exec($(this).attr('data-url'));
    if (category != null) category = category[1];
    if (category != null) {
      $('h1', this).text(Readings.config.get('categories')[category]);
      return $(this).Readings('list', {
        category: category,
        sql: "SELECT * FROM tag WHERE category=? ORDER BY sort_key",
        params: [category],
        filter: Readings.config.get('show_filter').indexOf(category) >= 0,
        mapper: function(rec) {
          return new Readings.Tag(rec, category);
        },
        dividers: Readings.config.get('show_dividers').indexOf(category) >= 0
      });
    }
    return alert('no category in query string');
  });

  $(document).on('pageinit', '#page-books', function(ev, ui) {
    var tag, tag_id, tag_id_m,
      _this = this;
    tag_id_m = rtagid.exec($(this).attr('data-url'));
    if (tag_id_m != null) tag_id = tag_id_m[1];
    return tag = Readings.catalogue.withTag(tag_id, function(tag) {
      return $(_this).Readings('list', {
        fetch: function(cb) {
          return Readings.catalogue.withBooks(tag, cb);
        },
        filter: true,
        dividers: tag.category !== 'author'
      });
    });
  });

  $(document).on('pageinit', '#page-reader', function(ev, ui) {
    var book_id, book_id_m;
    book_id_m = rbookid.exec($(this).attr('data-url'));
    if (book_id_m != null) book_id = book_id_m[1];
    return $(this).Readings('reader', {
      book_id: book_id
    });
  });

}).call(this);
