# main controller

Readings.category_list = (list) ->
  list.empty()
  for cat, labelname of Readings.config.get 'categories'
    list.append "<li><a href=\"#page-tags?category=#{cat}\">#{labelname}</a></li>"
  list.listview 'refresh'