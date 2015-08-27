var fs = require('fs');

Elm.Native.Log = {};

Elm.Native.Log.make = function(elm) {
  elm.Native = elm.Native || {};
  elm.Native.Log = elm.Native.Log || {};
  if (elm.Native.Log.values) return elm.Native.Log.values;

  function log (x) {
    console.log(x);
    return x;
  }

  return elm.Native.Log.values = {  // Export
    log: log,
  };

};
