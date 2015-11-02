module.exports =
  replace:  true
  template: require('./template')

  components: {}

  data: ->
    message: ''
    messages: []

  ready: ->
    @$socket.on 'message', (message) =>
      @$data.messages.push message

  methods:
    onSubmit: ->
      @$socket.emit 'message', @$data.message
      @$data.message = ''
