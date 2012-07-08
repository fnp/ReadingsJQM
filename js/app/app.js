(function() {

  window.Readings = {};

  $.fn.Readings = {};

  $(document).on('pageinit', function(ev) {
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
    return Readings.category_list($('#list-categories'));
  });

}).call(this);
