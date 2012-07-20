
class Readings.Catalogue
  open: () ->
    version = Readings.config.get 'db_version'
    console.log "opening db ver #{version}"
    @db = openDatabase 'catalogue', version, 'Catalogue', 65535, @init
    this

  init: (db) ->
    unneded_stmts = (stmt, idx) ->
      stmt.indexOf("PRAGMA")==0 or
      stmt.indexOf("BEGIN TRANSACTION")==0 or
      stmt.indexOf("COMMIT")==0 or
      /^\s*$/.exec stmt

    if not db?
      db = @db
    console.log "initializing DB"
    db.changeVersion "", Readings.config.get 'db_version'
    $.ajax Readings.config.get('initdburl'),
      type: "GET"
      dataType: 'text'
      success: (sql) =>
        sql = sql.split /;\n/
        sql = $.grep sql, unneded_stmts, true

        create = (tx) =>
          for stmt in sql
            tx.executeSql stmt, [],
              (tx,rs) => true,
              (tx,err) =>
                console.error("error for #{stmt}")
                console.error(err)

        db.transaction create
      error: =>
        console.error "can't get initial sql"

  wrap_error: (error_cb) ->
    (tx, error) ->
      window.last_error = error
      alert "SQL ERROR: #{error.message}"
      if error_cb
        error_cb(error)
      else
        throw error

  map_rs: (rs, mapper) ->
    objs = []
    for i in [0...rs.rows.length]
      objs.push(mapper(rs.rows.item(i)))
    return objs

## TODO update method
  withCategory: (category, callback, error) ->
    rs_to_tags = (tx, data) ->
      tags = []
      for i in [0...data.rows.length]
        tags.push new Readings.Tag(data.rows.item(i))
      callback(tags)

    @db.readTransaction (tx)=>
      tx.executeSql "SELECT * FROM tag WHERE category=? ORDER BY sort_key",
        [category], rs_to_tags, @wrap_error(error)

  withTag: (tag_id, cb) ->
    @db.readTransaction (tx) =>
      tx.executeSql "SELECT * FROM tag WHERE id=?", [tag_id],
        (tx, rs) =>
          if rs.rows.length > 0
            tag = new Readings.Tag rs.rows.item(0)
            return cb(tag)
          else
            alert "No tag id #{tag_id}"
        ,
        @wrap_error()

  withBooks: (tag, cb) ->
    @db.readTransaction (tx) =>
      console.log "books in tag: #{tag.books}"
      tx.executeSql "SELECT * FROM book WHERE id IN (#{tag.books}) ORDER BY sort_key",
        [], ((tx, rs) => cb(@map_rs(rs, (rec)->new Readings.Book(rec)))), @wrap_error()

  fetchBook: (book_id, fetch_contents, cb) ->
    unless typeof book_id == "number" or /^[0-9]+$/.exec book_id
      throw Error "book_id = '#{book_id}' is not a number"

    @db.readTransaction (tx) =>
      tx.executeSql "SELECT * FROM book WHERE id=?", [book_id],
        (tx, rs) =>
          if rs.rows.length > 0
            book = new Readings.Book rs.rows.item(0)
            if fetch_contents and not book.is_local()
              book.fetch (book) ->
                cb(book)
            else
              return cb(book)
