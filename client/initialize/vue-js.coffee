module.exports = ->
  Vue.use(VueRouter)
  # VueForm is initialized automatically

  Vue.mixin(require('../mixins/ajax'))
  Vue.mixin(require('../mixins/crud'))
  Vue.mixin(require('../mixins/socket'))

  $root   = Vue.extend(require('../components/$root'))
  $router = new VueRouter({ linkActiveClass: 'active' })

  $router.map require('../routes')()
  $router.start $root, '#app'
