_         = require('lodash')
pluralize = require('pluralize')

module.exports =
  modifiers:
    uppercase : (str) -> str.toUpperCase()
    lowercase : (str) -> str.toLowerCase()
    singular  : (str) -> pluralize(str, 1)
    plural    : (str) -> pluralize(str)
    capitalize: (str) -> _.capitalize(str)

  templates:
    'Client Component - General':
      files:
        'client/components/general/index.coffee': 'client/components/^^componentName^^/index.coffee'
        'client/components/general/template.html': 'client/components/^^componentName^^/template.html'
        'client/components/general/style.styl': 'client/components/^^componentName^^/style.styl'

    'Client Component - Page':
      files:
        'client/components/page/index.coffee': 'client/components/page-^^pageName^^/index.coffee'
        'client/components/page/template.html': 'client/components/page-^^pageName^^/template.html'
        'client/components/page/style.styl': 'client/components/page-^^pageName^^/style.styl'
        'client/components/page/route.coffee': 'client/routes/^^pageName^^.coffee'

    'Server Route Component':
      files:
        'server/route/route.coffee': 'server/routes/^^name^^.coffee'

    'Complete Entity (Client Components/Routes & Server Model/Route)':
      files:
        'client+server/entity/client/page-collection/index.coffee' : 'client/components/page-^^entityNamePlural^^/index.coffee'
        'client+server/entity/client/page-collection/style.styl'   : 'client/components/page-^^entityNamePlural^^/style.styl'
        'client+server/entity/client/page-collection/template.html': 'client/components/page-^^entityNamePlural^^/template.html'
        'client+server/entity/client/page-item/index.coffee'       : 'client/components/page-^^entityNameSingular^^/index.coffee'
        'client+server/entity/client/page-item/style.styl'         : 'client/components/page-^^entityNameSingular^^/style.styl'
        'client+server/entity/client/page-item/template.html'      : 'client/components/page-^^entityNameSingular^^/template.html'
        'client+server/entity/client/route.coffee'                 : 'client/routes/^^entityNamePlural^^.coffee'
        'client+server/entity/server/route.coffee'                 : 'server/routes/^^entityNamePlural^^.coffee'
        'client+server/entity/server/model.coffee'                 : 'server/models/^^entityNameSingular^^.coffee'
