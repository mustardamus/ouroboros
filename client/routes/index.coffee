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

  '/chat':
    name: 'chat'
    component: require('../components/page-chat')
    params:
      menu: { name: 'Chat', icon: 'plane' }

  '/user/:id':
    name: 'user'
    component: require('../components/page-user')
