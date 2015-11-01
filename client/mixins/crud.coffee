module.exports =
  methods:
    $crud: (id = null) ->
      unless @$data.entity
        return console.log("Set @$data.entity on VM before calling crud()")

      url  = @$data.entity
      url += "/#{id}" if(id)

      return window.crud(url)
