module.exports =
  '/^^entityNamePlural^^':
    name     : '^^entityNamePlural^^'
    component: require('../components/page-^^entityNamePlural^^')
    params:
      menu: { name: '^^entityNamePluralCapitalize^^', icon: 'plane' }

  '/^^entityNamePlural^^/:id':
    name     : '^^entityNameSingular^^'
    component: require('../components/page-^^entityNameSingular^^')
