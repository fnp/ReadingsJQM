(function() {

  Readings.Config = (function() {

    function Config(opts) {
      this.opts = opts;
    }

    Config.prototype.get = function(name) {
      return this.opts[name];
    };

    return Config;

  })();

}).call(this);
