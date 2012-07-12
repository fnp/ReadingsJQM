
class Readings.Tag
  constructor: (record, @category) ->
    @href = record.href
    @name = record.name
    #@url = record.url
    @slug = $.grep(@href.split('/'), (e) -> e != "")

  render: ->
    "<li><a href=\"#\">#{@name}</a></li>"

  group: ->
    if @category == 'authors'
      # last word, first letter
      @name.split(' ').slice(-1)[0][0].toUpperCase()
    else
      @name[0].toUpperCase()


$.fn.Readings.list = (opts) ->
  # category
  # url
  # mapper
  # title
  # filter
  # mapper (rec) -> obj
  this.each ->
    $('[data-role=header] h1').text opts.title
    list = $('[data-role=listview]', this)
    if !opts.filter
      $(".ui-listview-filter").hide()
    $.ajax
      url: opts.url
      contentType: "json"
      success: (data) ->
        objs = $.map data, opts.mapper
        list.empty()
        last_divider = null

        for obj in objs
          # throw a divider in for some categories
          if opts.dividers
            divider = obj.group()
            if last_divider != divider
              list.append "<li data-role=\"list-divider\">#{divider}</li>"
              last_divider = divider

          list.append obj.render()
        list.listview 'refresh'



$.fn.Readings.TagList = (category) ->
  this.each ->
    $('[data-role=header] h1').text Readings.config.get('categories')[category]
    list = $('[data-role=listview]', this)
    if Readings.config.get('show_filter').indexOf(category) < 0
      $(".ui-listview-filter").hide()
    $.ajax
      url: Readings.config.get('wlurl') + "/api/#{category}"
      contentType: "json"
      success: (data) ->
        tags = $.map data, (rec) -> new Readings.Tag(rec, category)
        list.empty()
        last_separator = null
        show_separator = Readings.config.get('show_dividers').indexOf(category) >= 0
        for t in tags
          # throw a separator in for some categories
          if show_separator
            separator = t.group()
            if last_separator != separator
              list.append "<li data-role=\"list-divider\">#{separator}</li>"
              last_separator = separator

          list.append t.render()
        list.listview 'refresh'
