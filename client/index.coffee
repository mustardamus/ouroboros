###
global ../bower_components/lodash/lodash.js
global ../node_modules/vue/dist/vue.js
global ../node_modules/vue-router/dist/vue-router.js
global # ../node_modules/vue-validator/dist/vue-validator.js
global ../bower_components/zepto/zepto.js
global ../node_modules/socket.io-client/socket.io.js
global ../node_modules/node-crud/dist/crud.js

global #../bower_components/semantic/dist/components/accordion.js
global #../bower_components/semantic/dist/components/checkbox.js
global #../bower_components/semantic/dist/components/dimmer.js
global #../bower_components/semantic/dist/components/dropdown.js
global #../bower_components/semantic/dist/components/embed.js
global #../bower_components/semantic/dist/components/modal.js
global #../bower_components/semantic/dist/components/nag.js
global #../bower_components/semantic/dist/components/popup.js
global #../bower_components/semantic/dist/components/progress.js
global #../bower_components/semantic/dist/components/rating.js
global #../bower_components/semantic/dist/components/search.js
global #../bower_components/semantic/dist/components/shape.js
global #../bower_components/semantic/dist/components/sidebar.js
global #../bower_components/semantic/dist/components/sticky.js
global #../bower_components/semantic/dist/components/tab.js
global #../bower_components/semantic/dist/components/transition.js
###

$ ->
  window.jQuery = $ # proxy for semantic-ui/other libs that use 'window.jQuery'

  for n, initFunc of require('./initialize/*.coffee', { mode: 'hash' })
    initFunc.call @
