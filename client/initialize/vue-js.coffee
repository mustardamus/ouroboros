module.exports = ->
  Vue.use(VueRouter)
  Vue.mixin(require('../mixins/ajax'))

  $root   = Vue.extend(require('../components/$root'))
  $router = new VueRouter({ linkActiveClass: 'active' })

  $router.map require('../routes')
  $router.start $root, '#app'
