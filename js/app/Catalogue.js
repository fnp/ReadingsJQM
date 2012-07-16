// Generated by CoffeeScript 1.3.3
(function() {

  Readings.Catalogue = (function() {

    function Catalogue() {}

    Catalogue.prototype.open = function() {
      var version;
      version = Readings.config.get('db_version');
      console.log("opening db ver " + version);
      this.db = openDatabase('catalogue', version, 'Catalogue', 65535, this.init);
      return this;
    };

    Catalogue.prototype.init = function(db) {
      var _this = this;
      if (!(db != null)) {
        db = this.db;
      }
      console.log("initializing DB");
      db.changeVersion("", Readings.config.get('db_version'));
      return $.ajax("initdb.sql", {
        type: "GET",
        dataType: 'text',
        success: function(sql) {
          var create;
          sql = sql.split(/;\n/);
          sql = sql.slice(1, -2);
          create = function(tx) {
            var stmt, _i, _len, _results;
            _results = [];
            for (_i = 0, _len = sql.length; _i < _len; _i++) {
              stmt = sql[_i];
              console.log(stmt);
              _results.push(tx.executeSql(stmt, [], function(tx, rs) {
                return true;
              }, function(tx, err) {
                return console.error(err);
              }));
            }
            return _results;
          };
          return db.transaction(create);
        },
        error: function() {
          return console.error("can't get initial sql");
        }
      });
    };

    Catalogue.prototype.wrap_error = function(error_cb) {
      return function(tx, error) {
        window.last_error = error;
        alert("SQL ERROR: " + error.message);
        if (error_cb) {
          return error_cb(error);
        } else {
          throw error;
        }
      };
    };

    Catalogue.prototype.map_rs = function(rs, mapper) {
      var i, objs, _i, _ref;
      objs = [];
      for (i = _i = 0, _ref = rs.rows.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        objs.push(mapper(rs.rows.item(i)));
      }
      return objs;
    };

    Catalogue.prototype.withCategory = function(category, callback, error) {
      var rs_to_tags,
        _this = this;
      rs_to_tags = function(tx, data) {
        var i, tags, _i, _ref;
        tags = [];
        for (i = _i = 0, _ref = data.rows.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          tags.push(new Readings.Tag(data.rows.item(i)));
        }
        return callback(tags);
      };
      return this.db.readTransaction(function(tx) {
        return tx.executeSql("SELECT * FROM tag WHERE category=? ORDER BY sort_key", [category], rs_to_tags, _this.wrap_error(error));
      });
    };

    Catalogue.prototype.withTag = function(tag_id, cb) {
      var _this = this;
      return this.db.readTransaction(function(tx) {
        return tx.executeSql("SELECT * FROM tag WHERE id=?", [tag_id], function(tx, rs) {
          var tag;
          if (rs.rows.length > 0) {
            tag = new Readings.Tag(rs.rows.item(0));
            return cb(tag);
          } else {
            return alert("No tag id " + tag_id);
          }
        }, _this.wrap_error());
      });
    };

    Catalogue.prototype.withBooks = function(tag, cb) {
      var _this = this;
      return this.db.readTransaction(function(tx) {
        console.log("books in tag: " + tag.books);
        return tx.executeSql("SELECT * FROM book WHERE id IN (" + tag.books + ") ORDER BY sort_key", [], (function(tx, rs) {
          return cb(_this.map_rs(rs, function(rec) {
            return new Readings.Book(rec);
          }));
        }), _this.wrap_error());
      });
    };

    return Catalogue;

  })();

}).call(this);
