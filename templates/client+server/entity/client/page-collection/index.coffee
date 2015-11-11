module.exports =
  template  : require('./template')
  components: {}

  data: ->
    entity: '^^entityNamePlural^^'
    errorMessage: ''
    ^^entityNamePlural^^: []
    ^^entityNameSingular^^: { name: '' }

  ready: ->
    @$crud().read (err, ^^entityNamePlural^^) =>
      @$data.^^entityNamePlural^^ = ^^entityNamePlural^^

  methods:
    setFormError: (message) ->
      @$data.errorMessage = message
      $('form', @$el).removeClass('loading').addClass 'error'
      $('input', @$el).first().focus()

    onSubmit: ->
      $('form', @$el).addClass 'loading'

      @$crud().create @$get('^^entityNameSingular^^'), (err, ^^entityNameSingular^^) =>
        if err
          @setFormError err.message
        else
          @$data.^^entityNamePlural^^.push ^^entityNameSingular^^
          @$route.router.go { path: "/#{@$data.entity}/#{^^entityNameSingular^^._id}"}

    onDelete: (id) ->
      @$crud(id).del (err, res) =>
        if err
          @setFormError err.message
        else
          @$data.^^entityNamePlural^^ = _.remove @$data.^^entityNamePlural^^, (^^entityNameSingular^^) ->
            ^^entityNameSingular^^._id isnt id
