module.exports =
  template: require('./template')

  data: ->
    errorMessage: ''
    email       : ''

  methods:
    onSubmit: ->
      @resetRequest() if @form.$valid

    resetRequest: ->
      $('form', @$el).addClass 'loading'

      @$ajax 'post', '/api/forgot-password', { email: @$data.email }, (err, response) ->
        if err
          $('form', @$el).addClass('error').removeClass('loading success')
          $('input', @$el).first().focus()

          @$data.errorMessage = JSON.parse(err.response).message
        else
          $('form', @$el).removeClass('error loading').addClass 'success'
