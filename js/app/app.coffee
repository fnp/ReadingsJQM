
window.Readings = {}
$.fn.Readings = {}


$(document).on 'pageinit', (ev) ->
  Readings.config = new Readings.Config
    wlurl: 'http://readings.local'
    categories:
      'authors': 'autor',
      'epochs': 'epoka',
      'genres': 'gatunek',
      'kinds': 'rodzaj',
      'themes': 'motyw'

  Readings.category_list $('#list-categories')