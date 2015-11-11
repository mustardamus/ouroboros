module.exports =
  methods:
    $crud: (id = null) ->
      unless @$data.entity
        return console.log('Set @$data.entity on VM before calling crud()')

      urlObj  = {}
      url     = @$data.entity
      url    += "/#{id}" if(id)

      if @$root.$data.currentToken
        urlObj.token = @$root.$data.currentToken

      return window.crud(url, urlObj)
