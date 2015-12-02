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
    onSubmit: ->
      @registerRequest() if @form.$valid

    passwordMatch: (val) ->
      val is @$data.password

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
