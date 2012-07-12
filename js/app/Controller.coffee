# main controller

$.fn.Readings.CategoryList = ->
  list = $(this)
  list.empty()
  for cat, labelname of Readings.config.get 'categories'
    list.append "<li><a href=\"tags.html?category=#{cat}\" data-category=\"#{cat}\">#{labelname}</a></li>"
  # $('a', list).on 'tap', (ev) ->
  #   ev.preventDefault()
  #   $i = $(this)
  #   category = $i.data 'category'
  #   false
#    $.mobile.changePage '#page-tags',
#      category: category
  list.listview 'refresh'
