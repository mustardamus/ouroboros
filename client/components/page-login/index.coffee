module.exports =
  template: require('./template')

  data: ->
    username: ''
    password: ''

  ready: ->
    $('input', @$el).first().focus()

  methods:
    onSubmit: ->
      @loginRequest() if @form.$valid

    loginRequest: ->
      $('form', @$el).addClass 'loading'

      data = { username: @$data.username, password: @$data.password }

      @$ajax 'post', '/api/login', data, (err, response) ->
        if err
          $('form', @$el).addClass('error').removeClass('loading')
          $('input', @$el).first().focus()
        else
          $('form', @$el).removeClass 'error loading'

          @$root.$data.currentToken = response.token
          @$route.router.go { name: 'home' }
