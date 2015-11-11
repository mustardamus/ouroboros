module.exports =
  template: require('./template')

  data: ->
    entity       : 'users'
    username     : ''
    password     : ''
    passwordCheck: ''
    errorMessage : ''

  ready: ->
    $('input', @$el).first().focus()

  methods:
    onRegisterClick: ->
      @registerRequest() if @validateForm()

    validateForm: ->
      valid = true

      if $.trim(@$data.username).length is 0
        valid = false
        $('#username-field', @$el).addClass 'error'

      if $.trim(@$data.password).length is 0
        valid = false
        $('#password-field', @$el).addClass 'error'

      if $.trim(@$data.passwordCheck).length is 0 or @$data.password isnt @$data.passwordCheck
        valid = false
        $('#password-check-field', @$el).addClass 'error'

      if valid
        $('.field.error', @$el).removeClass 'error'

      valid

    setFormError: (message) ->
      @$data.errorMessage = message
      $('form', @$el).removeClass('loading').addClass 'error'
      $('input', @$el).first().focus()

    registerRequest: ->
      $('form', @$el).addClass 'loading'

      data =
        username: _.trim(@$data.username)
        password: _.trim(@$data.password)

      @$crud().create data, (err, res) =>
        if err
          @setFormError err.message
        else
          @$root.$data.currentToken = res.token
          @$route.router.go { name: 'home', params: { id: res.userId }}
