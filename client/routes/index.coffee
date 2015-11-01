module.exports =
  '/':
    name     : 'home'
    component: require('../components/page-home')
    params:
      menu: true

  '/users':
    name: 'users'
    component: require('../components/page-users')
    params:
      menu: { icon: 'users' }
