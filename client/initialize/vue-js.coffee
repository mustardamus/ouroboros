module.exports = ->
  Vue.use(VueRouter)

  Vue.mixin(require('../mixins/ajax'))
  Vue.mixin(require('../mixins/crud'))

  $root   = Vue.extend(require('../components/$root'))
  $router = new VueRouter({ linkActiveClass: 'active' })

  $router.map require('../routes')
  $router.start $root, '#app'
