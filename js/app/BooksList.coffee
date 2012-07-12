
slug_in_url = /([a-z0-9-]+)[/]?$/

class Readings.Book
  constructor: (record) ->
    @url = record.url
    @href = record.href
    @cover = record.cover
    @author = record.author
    @title = record.title
    @slug = slug_in_url.exec(@href)[1]

  render: ->
    "<li><a href=\"reader.html?slug=#{@slug}\">#{@title}</a></li>"

  group: ->
    @author


$.fn.Readings.BookList = (category, tag) ->
  this.each ->
    $('[data-role=header] h1').text tag.name
    list = $('[data-role=listview]', this)
    $.ajax
      url: "#{tag.href}books/"
      #url: Readings.config.get('wlurl') + "/api/#{category}"
      contentType: "json"
      success: (data) ->
        console.log(data)
        books = $.map data, (rec) -> new Readings.Book(rec)
        list.empty()
        last_separator = null
        show_separator = !(category == 'authors')

        for b in books
          # throw a separator in for some categories
          if show_separator
            separator = t.group()
            if last_separator != separator
              list.append "<li data-role=\"list-divider\">#{separator}</li>"
              last_separator = separator

          list.append b.render()
          list.listview 'refresh'
