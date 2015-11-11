module.exports =
  '/':
    name     : 'home'
    component: require('../components/page-home')
    params:
      menu: { name: 'Home', icon: 'home' }

  '/chat':
    name: 'chat'
    component: require('../components/page-chat')
    params:
      menu: { name: 'Chat', icon: 'plane' }
