
$.fn.Readings.list = (opts) ->
  # category
  # url
  # mapper
  # title
  # filter
  # mapper (rec) -> obj
  #
  this.each ->
    $('[data-role=header] h1').text opts.title
    list = $('[data-role=listview]', this)
    console.log "lst1 #{list.length}"

    # show filter search?
    if !opts.filter
      $(".ui-listview-filter").hide()

    # display elements
    render = (objs) =>
      console.log("lst #{list.length}")
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

    if opts.sql
      Readings.catalogue.db.transaction (tx) ->
        tx.executeSql opts.sql, opts.params,
        (tx, rs) ->
          objs = []
          for i in [0...rs.rows.length]
            objs.push opts.mapper rs.rows.item i
          render(objs)
        ,
        (tx, err) ->
          window.last_error = err
          alert "SQL Error while fetching list contents: #{err.message}"

    if opts.url
      $.ajax
        url: opts.url
        contentType: "json"
        success: (data) -> render($.map(data, opts.mapper))

    if opts.fetch
      opts.fetch(render)

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
