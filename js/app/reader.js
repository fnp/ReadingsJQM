// Generated by CoffeeScript 1.3.3
(function() {

  $.fn.extend({
    load_book: function(slug) {
      return this.each(function() {
        var _this = this;
        return $.ajax({
          type: 'GET',
          contentType: 'html',
          url: '/fixtures/katalog_lektura_lord-jim.html',
          error: function(e) {
            return console.log("Error " + e);
          },
          success: function(page) {
            var $page, $text, $toc;
            $page = $(page);
            $text = $page.find('#book-text');
            $toc = $text.find('#toc');
            _this.toc = $toc.find('a').map(function(_i, link) {
              return {
                anchor: link.href,
                label: $(link).text()
              };
            });
            $toc.remove();
            _this.text = $text;
            return $('[data-role=header] h1', _this).text(_this.text.find('h1 .title').text());
          }
        });
      });
    }
  });

}).call(this);