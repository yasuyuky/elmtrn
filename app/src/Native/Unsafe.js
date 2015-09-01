Elm.Native.Unsafe = {};

Elm.Native.Unsafe.make = function(elm) {
  elm.Native = elm.Native || {};
  elm.Native.Unsafe = elm.Native.Unsafe || {};
  if (elm.Native.Unsafe.values) return elm.Native.Unsafe.values;

  function unsignal(x) {
    return x.value;
  }

  return elm.Native.Unsafe.values = {  // Export
    unsignal: unsignal,
  };

};
