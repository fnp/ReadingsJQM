
class Readings.Tag
  constructor: (record) ->
    @href = record.href
    @name = record.name
    #@url = record.url
    @slug = $.grep(@href.split('/'), (e) -> e != "")

  render: ->
    "<li><a href=\"#\">#{@name}</a></li>"

$.fn.Readings.TagList = (category) ->
#  dont_filter = ['kinds']
  this.each ->
    $('[data-role=header] h1').text Readings.config.get('categories')[category]
    list = $('[data-role=listview]', this)
#    list.listview
#      filter: dont_filter.indexOf(category) < 0
    $.ajax
      url: Readings.config.get('wlurl') + "/api/#{category}"
      contentType: "json"
      success: (data) ->
        console.log(data)
        tags = $.map data, (rec) -> new Readings.Tag(rec)
        list.empty()
        for t in tags
          list.append t.render()
        list.listview 'refresh'
