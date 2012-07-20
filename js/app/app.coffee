
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
    wlurl: 'http://dev.wolnelektury.pl'
    initdburl: 'http://dev.wolnelektury.pl/media/api/mobile/initial/initial.sql'
    categories:
      'author': 'autor',
      'epoch': 'epoka',
      'genre': 'gatunek',
      'kind': 'rodzaj',
     # 'themes': 'motyw'
    show_filter: [ 'authors', 'themes' ]
    show_dividers: [ 'authors', 'themes']
    db_version: '1.0'
  Readings.catalogue = new Readings.Catalogue().open()
  Readings.initialized = true

$(document).on 'pageinit', '#page-categories' , (ev) ->
  Readings.init()
  $('#list-categories').Readings 'CategoryList'

rcategory = /category=(\w+)/
rtag = /tag=([a-z0-9-]+)/
rtagid = /tag_id=([0-9]+)/
rbookid = /book_id=([0-9]+)/

$(document).on 'pageinit', "#page-tags", (ev, ui) ->
  category = rcategory.exec($(this).attr('data-url'))
  category = category[1] if category?
  if category?
    $('h1',this).text Readings.config.get('categories')[category]
    return $(this).Readings 'list',
      category: category
      #url: Readings.config.get('wlurl') + "/api/#{category}"
      sql: "SELECT * FROM tag WHERE category=? ORDER BY sort_key"
      params: [category]
      filter: (Readings.config.get('show_filter').indexOf(category) >= 0)
      mapper: (rec) -> new Readings.Tag(rec, category)
      dividers: (Readings.config.get('show_dividers').indexOf(category) >= 0)
  alert 'no category in query string'

$(document).on 'pageinit', '#page-books', (ev, ui) ->
  tag_id_m = rtagid.exec($(this).attr('data-url'))
  tag_id = tag_id_m[1] if tag_id_m?

  tag = Readings.catalogue.withTag tag_id, (tag) =>
    $(this).Readings 'list',
      fetch: (cb) -> Readings.catalogue.withBooks(tag, cb)
      filter: true
      dividers: (tag.category != 'author')


$(document).on 'pageinit', '#page-reader', (ev, ui) ->
  book_id_m = rbookid.exec($(this).attr('data-url'))
  book_id = book_id_m[1] if book_id_m?
  $(this).Readings 'reader',
    book_id: book_id