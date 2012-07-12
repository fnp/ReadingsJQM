// Generated by CoffeeScript 1.3.3
(function() {
  var slug_in_url;

  slug_in_url = /([a-z0-9-]+)[/]?$/;

  Readings.Book = (function() {

    function Book(record) {
      this.url = record.url;
      this.href = record.href;
      this.cover = record.cover;
      this.author = record.author;
      this.title = record.title;
      this.slug = slug_in_url.exec(this.href)[1];
    }

    Book.prototype.render = function() {
      return "<li><a href=\"reader.html?slug=" + this.slug + "\">" + this.title + "</a></li>";
    };

    Book.prototype.group = function() {
      return this.author;
    };

    return Book;

  })();

  $.fn.Readings.BookList = function(category, tag) {
    return this.each(function() {
      var list;
      $('[data-role=header] h1').text(tag.name);
      list = $('[data-role=listview]', this);
      return $.ajax({
        url: "" + tag.href + "books/",
        contentType: "json",
        success: function(data) {
          var b, books, last_separator, separator, show_separator, _i, _len, _results;
          console.log(data);
          books = $.map(data, function(rec) {
            return new Readings.Book(rec);
          });
          list.empty();
          last_separator = null;
          show_separator = !(category === 'authors');
          _results = [];
          for (_i = 0, _len = books.length; _i < _len; _i++) {
            b = books[_i];
            if (show_separator) {
              separator = t.group();
              if (last_separator !== separator) {
                list.append("<li data-role=\"list-divider\">" + separator + "</li>");
                last_separator = separator;
              }
            }
            list.append(b.render());
            _results.push(list.listview('refresh'));
          }
          return _results;
        }
      });
    });
  };

}).call(this);
