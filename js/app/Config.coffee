
class Readings.Config
  constructor: (@opts) ->

  key: (name) ->
    "config.#{name}"

  get: (name) ->
    v = localStorage.getItem @key(name)
    if v?
      return JSON.parse(v)
    @opts[name]

  save: (name, value) ->
    localStorage.setItem @key(name), JSON.stringify(value)