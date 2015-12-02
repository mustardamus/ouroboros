module.exports =
  template: require('./template')

  data: ->
    entity          : 'users'
    currentUser     : @$root.$data.currentUser
    changePassword  : false
    passwordOld     : ''
    passwordNew     : ''
    passwordNewCheck: ''
    errorMessage    : ''

  ready: ->
    @$root.$watch 'currentUser', (val) =>
      @$data.currentUser = val
      @checkEmptyMail()

    @checkEmptyMail()

  methods:
    checkEmptyMail: ->
      unless @currentUser.email
        $('#email', @$el).focus()
      else
        $('#username', @$el).focus()

    passwordMatch: (val) ->
      val is @$data.passwordNew

    onChangePasswordClick: ->
      @$data.changePassword = !@$data.changePassword

      setTimeout =>
        if @$data.changePassword
          $('#password-old', @$el).focus()
        else
          @checkEmptyMail()
      , 100

    onSubmit: ->
      @updateRequest() if @form.$valid

    updateRequest: ->
      data =
        username: @$data.currentUser.username
        email   : @$data.currentUser.email

      if @$data.changePassword
        data =
          passwordOld: @$data.passwordOld
          passwordNew: @$data.passwordNew

      $('form', @$el).addClass 'loading'

      @$crud('me', true).update data, (err, user) =>
        unless err
          @onUpdateSuccess user
        else
          @onUpdateError err

    onUpdateSuccess: (user) ->
      @$root.$data.currentUser  = user

      @resetPasswordFields()
      $('form', @$el).removeClass('loading error').addClass('success')

    onUpdateError: (err) ->
      @$data.errorMessage = err.message

      @resetPasswordFields()
      $('form', @$el).removeClass('loading success').addClass('error')

      if @$data.errorMessage is 'Username already exists'
        $('#username', @$el).focus()
      else
        @checkEmptyMail()

      if @$data.changePassword
        $('#password-old', @$el).focus()

    resetPasswordFields: ->
      @$data.passwordOld      = ''
      @$data.passwordNew      = ''
      @$data.passwordNewCheck = ''
