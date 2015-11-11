module.exports =
  template  : require('./template')
  components: {}

  data: ->
    entity      : '^^entityNamePlural^^'
    ^^entityNameSingular^^: null
    errorMessage: ''
    notFound    : null

  ready: ->
    @$crud(@$route.params.id).read (err, ^^entityNameSingular^^) =>
      if ^^entityNameSingular^^
        @$data.^^entityNameSingular^^ = ^^entityNameSingular^^
        @$data.notFound = false
      else
        @$data.notFound = true

  methods:
    setFormError: (message) ->
      @$data.errorMessage = message
      $('form', @$el).removeClass('loading').addClass 'error'

    onSubmit: ->
      $('form', @$el).addClass 'loading'

      @$crud(@$data.^^entityNameSingular^^._id).update @$get('^^entityNameSingular^^'), (err, ^^entityNameSingular^^) =>
        if err
          @setFormError err.message
        else
          @$data.^^entityNameSingular^^ = ^^entityNameSingular^^
          $('form', @$el).removeClass 'error loading'

    onDelete: ->
      @$crud(@$data.^^entityNameSingular^^._id).del (err) =>
        if err
          @setFormError err.message
        else
          @$route.router.go { path: "/#{@$data.entity}"}
