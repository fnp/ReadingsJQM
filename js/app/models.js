(function() {
  var url_to_slug;

  url_to_slug = function(url) {
    var slug_in_url;
    slug_in_url = /([a-z0-9-]+)[/]?$/;
    return slug_in_url.exec(url)[1];
  };

  Readings.Book = (function() {

    function Book(record) {
      $.extend(this, record);
    }

    Book.prototype.render = function() {
      var wlurl;
      wlurl = Readings.config.get('wlurl');
      return "<li>      <a href=\"reader.html?book_id=" + this.id + "\">        <img src=\"" + wlurl + this.cover + "\">        <h3>" + this.title + "</h3>       </a>     </li>";
    };

    Book.prototype.group = function() {
      return this.authors;
    };

    Book.prototype.is_local = function() {
      var html;
      html = localStorage.getItem("html:" + this.id);
      return !(html === null);
    };

    Book.prototype.get_text = function() {
      var html;
      if (this._local) {
        html = localStorage.getItem("html:" + this.id);
        if (html) return $(html);
      }
      return null;
    };

    Book.prototype.fetch = function(cb) {
      var _this = this;
      return $.ajax(Readings.config.get("wlurl" + ("/katalog/lektura/" + this.slug + ".html"), {
        type: 'get',
        dataType: 'html',
        success: function(text) {
          text = _this.mobilize_html(text);
          localStorage.setItem("html:" + _this.id, text);
          _this._local = 1;
          return _this.db.transaction(function(tx) {
            return tx.executeSql("UPDATE _local = 1 WHERE id=?", [_this.id], function(tx, rs) {
              return cb(_this);
            });
          });
        },
        error: function(er) {
          throw Error("Error fetching book text slug=" + this.slug + ", " + er);
        }
      }));
    };

    Book.prototype.mobilize_html = function(html) {
      var book_text;
      html = $(html);
      book_text = html.find("#book-id");
      html.find("#download, #header, #themes")["delete"]();
      return book_text;
    };

    return Book;

  })();

  Readings.Tag = (function() {

    function Tag(record, category) {
      this.category = category;
      $.extend(this, record);
    }

    Tag.prototype.render = function() {
      return "<li><a href=\"books.html?tag_id=" + this.id + "\">" + this.name + "</a></li>";
    };

    Tag.prototype.group = function() {
      return this.sort_key[0].toUpperCase();
    };

    return Tag;

  })();

}).call(this);
