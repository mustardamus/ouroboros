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

  '/posts':
    name: 'posts'
    component: require('../components/page-posts')
    params:
      menu: { name: 'Posts', icon: 'plane' }

  '/posts/:id':
    name: 'post'
    component: require('../components/page-post')
