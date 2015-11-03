var coffee = require('coffee-script/register');
var glob   = require('glob');

var files  = glob.sync(__dirname + '/**/spec*.coffee');
var outObj = {};

for(var i = 0; i < files.length; i++) {
  var test = require(files[i]);

  for(var key in test) {
    outObj[key] = test[key];
  }
}

module.exports = outObj;
