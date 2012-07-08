
class Readings.Config
  constructor: (@opts) ->

  get: (name) ->
    @opts[name]
