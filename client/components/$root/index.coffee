routes = require('../../routes')()

module.exports =
  template  : require('./template')
  data      : require('./data')
  components: { auth: require('../auth') }

  ready: ->
    for url, routeObj of routes
      if routeObj.params and routeObj.params.menu
        menuObj = _.extend(routeObj.params.menu, { url: url })

        @$data.menuItems.push menuObj
