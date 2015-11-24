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

    onChangePasswordClick: ->
      @$data.changePassword = !@$data.changePassword

      setTimeout =>
        if @$data.changePassword
          $('#password-old', @$el).focus()
        else
          @checkEmptyMail()
      , 100

    onUpdateClick: ->
      @updateRequest() if @validateForm()

    isValidEmail: (email) ->
      re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
      re.test(email)

    validateForm: ->
      valid = true

      unless @$data.changePassword
        if $.trim(@$data.currentUser.username).length is 0
          valid = false
          $('#username-field', @$el).addClass 'error'

        unless @isValidEmail(@$data.currentUser.email)
          valid = false
          $('#email-field', @$el).addClass 'error'
      else
        if $.trim(@$data.passwordOld).length is 0
          valid = false
          $('#password-old-field', @$el).addClass 'error'

        if $.trim(@$data.passwordNew).length is 0
          valid = false
          $('#password-new-field', @$el).addClass 'error'

        if $.trim(@$data.passwordNewCheck).length is 0
          valid = false
          $('#password-new-check-field', @$el).addClass 'error'

        if @$data.passwordNew isnt @$data.passwordNewCheck
          valid = false
          $('#password-new-check-field', @$el).addClass 'error'

      if valid
        $('.field.error', @$el).removeClass 'error'

      valid

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
