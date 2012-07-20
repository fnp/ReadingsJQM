

url_to_slug = (url) ->
  slug_in_url = /([a-z0-9-]+)[/]?$/
  slug_in_url.exec(url)[1]

class Readings.Book
  constructor: (record) ->
    $.extend(this, record)

  render: ->
    wlurl = Readings.config.get 'wlurl'
    "<li>
      <a href=\"reader.html?book_id=#{@id}\">
        <img src=\"#{wlurl}#{@cover}\">
        <h3>#{@title}</h3>
       </a>
     </li>"

  group: ->
    @authors

  is_local: ->
    html = localStorage.getItem("html:#{@id}")
    return not (html == null)

  get_text: ->
    if @_local
      html = localStorage.getItem("html:#{@id}")
      return $(html) if html
    null

  # fetches books content from WL
  # and pass it to callback
  fetch: (cb) ->
    $.ajax Readings.config.get "wlurl" + "/katalog/lektura/#{@slug}.html",
      type: 'get',
      dataType: 'html',
      success: (text) =>
        text = @mobilize_html text
        localStorage.setItem("html:#{@id}", text)
        @_local = 1
        @db.transaction (tx) =>
          tx.executeSql "UPDATE _local = 1 WHERE id=?", [@id], (tx, rs) =>
            cb this
      error: (er) ->
        throw Error "Error fetching book text slug=#{@slug}, #{er}"

  mobilize_html: (html) ->
    html = $(html)
    book_text = html.find("#book-id")
    html.find("#download, #header, #themes").delete()
    book_text


class Readings.Tag
  constructor: (record, @category) ->
    $.extend(this, record)

  render: ->
    "<li><a href=\"books.html?tag_id=#{@id}\">#{@name}</a></li>"

  group: ->
    @sort_key[0].toUpperCase()
    # if @category == 'author'
    #   # last word, first letter
    #   @name.split(' ').slice(-1)[0][0].toUpperCase()
    # else
    #   @name[0].toUpperCase()



# $.fn.Readings.BookList = (category, tag) ->
#   this.each ->
#     $('[data-role=header] h1').text tag.name
#     list = $('[data-role=listview]', this)
#     $.ajax
#       url: "#{tag.href}books/"
#       #url: Readings.config.get('wlurl') + "/api/#{category}"
#       contentType: "json"
#       success: (data) ->
#         console.log(data)
#         books = $.map data, (rec) -> new Readings.Book(rec)
#         list.empty()
#         last_separator = null
#         show_separator = !(category == 'authors')

#         for b in books
#           # throw a separator in for some categories
#           if show_separator
#             separator = t.group()
#             if last_separator != separator
#               list.append "<li data-role=\"list-divider\">#{separator}</li>"
#               last_separator = separator

#           list.append b.render()
#           list.listview 'refresh'
