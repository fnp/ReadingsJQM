
class Readings.Tag
  constructor: (record) ->
    @href = record.href
    @name = record.name
    #@url = record.url
    @slug = $.grep(@href.split('/'), (e) -> e != "")


  render: ->
    "<li"

$.fn.Readings.TagList = (category) ->
    this.each ->
      list = $(this)
      $.ajax
        url: Readings.config.get('wlurl') + "/api/#{@category}"
        contentType: "json"
        success: (data) ->
          console.log(data)
          tags = $.map data, (rec) -> new Readings.Tag(rec)
          list.empty()
          for t in tags
            list.append t.render()


class Readings.TagList
  defaults: null
  constructor: (list, options) ->
    @options = $.extend @defaults, options
    if not list.tag_list?
      list.tag_list = this
    list.tag_list

  load: ->
    $.ajax
      url: Readings.config.get('wlurl') + "/api/#{@category}"
      success: ->
        true
