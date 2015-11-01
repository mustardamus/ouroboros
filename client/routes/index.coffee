module.exports =
  '/':
    name     : 'home'
    component: require('../components/page-home')
    params:
      menu: { name: 'Home', icon: 'home' }

  '/users':
    name: 'users'
    component: require('../components/page-users')
    params:
      menu: { name: 'All Users', icon: 'users' }
