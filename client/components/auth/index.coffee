module.exports =
  data: ->
    entity: 'users'

  ready: ->
    @$root.$watch 'currentToken', (token) =>
      if token is null
        @logout()
      else
        localStorage.setItem 'token', token
        @getCurrentUser()

    token = localStorage.getItem('token')
    @$root.$data.currentToken = token if(token)

    window.onhashchange = =>
      if location.hash is '#!/logout'
        @$root.$data.currentToken = null

  methods:
    logout: ->
      @$root.$data.loggedIn    = false
      @$root.$data.currentUser = null

      localStorage.removeItem 'token'
      @$route.router.go { name: 'home' }

    getCurrentUser: ->
      @$crud('me').read (err, user) =>
        if err
          @$root.$data.loggedIn    = false
          @$root.$data.currentUser = null
        else
          @$root.$data.loggedIn    = true
          @$root.$data.currentUser = user
