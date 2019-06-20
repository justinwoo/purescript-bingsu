// parameter labels must be renamed for use with node-sqlite3
exports.renameParamLabels = function(r) {
  var o = {};
  for (var k in r) {
    o["$" + k] = r[k];
  }
  return o;
};
