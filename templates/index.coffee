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
    'Client Component':
      files:
        'client/components/index.coffee': 'client/components/^^nameSingular^^/index.coffee'
        'client/components/style.styl': 'client/components/^^namePluralLowercase^^/style.styl'

    'Server Route Component':
      files:
        'server/route/route.coffee': 'server/routes/^^name^^.coffee'

    'Complete Entity (Client Components & Server Model/Route)':
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
