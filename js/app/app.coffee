
window.Readings = {}

# Readings jquery plugin dispatcher.
$.fn.Readings =  ->
  meth = arguments[0]
  args = []
  for a in arguments
    args.push a
  args.shift()
  $.fn.Readings[meth].apply(this, args)


Readings.init = ->
  if Readings.initialized?
    return
  Readings.config = new Readings.Config
    wlurl: 'http://readings.local'
    categories:
      'authors': 'autor',
      'epochs': 'epoka',
      'genres': 'gatunek',
      'kinds': 'rodzaj',
      'themes': 'motyw'
    show_filter: [ 'authors', 'themes' ]
    show_dividers: [ 'authors', 'themes']
  Readings.initialized = true

$(document).on 'pageinit', '#page-categories' , (ev) ->
  Readings.init()
  $('#list-categories').Readings 'CategoryList'

rcategory = /category=(\w+)/
$(document).on 'pageinit', "#page-tags", (ev, ui) ->
  category = rcategory.exec($(this).attr('data-url'))
  if category? and category[1]?
    $(this).Readings 'list',
      category: category[1]
      url: Readings.config.get('wlurl') + "/api/#{category[1]}"
      filter: (Readings.config.get('show_filter').indexOf(category[1]) >= 0)
      mapper: (rec) -> new Readings.Tag(rec, category[1])
      dividers: (Readings.config.get('show_dividers').indexOf(category[1]) >= 0)
  else
    alert 'no category in query string'