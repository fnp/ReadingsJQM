

$.fn.extend
  load_book: (slug) ->
    this.each ->
      $.ajax
        type: 'GET',
        contentType: 'html',
        url: '/fixtures/katalog_lektura_lord-jim.html',
        error: (e) ->
          console.log "Error #{e}"
        success: (page) =>
          $page = $(page)
          $text = $page.find '#book-text'
          $toc = $text.find '#toc'

          this.toc = $toc.find('a').map (_i, link) =>
            {
              anchor: link.href,
              label: $(link).text()
            }

          $toc.remove()
          this.text = $text

          $('[data-role=header] h1', this).text(
            this.text.find('h1 .title').text()
            )
