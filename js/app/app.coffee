
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
  Readings.initialized = true

$(document).on 'pageinit', '#page-categories' , (ev) ->
  Readings.init()
  $('#list-categories').Readings 'CategoryList'

rcategory = /category=(\w+)/
$(document).on 'pageshow', "#page-tags", (ev, ui) ->
  category = rcategory.exec($(this).attr('data-url'))
  if category? and category[1]?
    $(this).Readings 'TagList', category[1]
