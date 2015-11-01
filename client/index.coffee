###
global ../node_modules/vue/dist/vue.js
global ../node_modules/vue-router/dist/vue-router.js
global ../bower_components/zepto/zepto.js
###

$ ->
  window.jQuery = $ # proxy for semantic-ui

  for n, initFunc of require('./initialize/*.coffee', { mode: 'hash' })
    initFunc.call @
