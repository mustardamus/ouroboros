module.exports =
  template: require('./template')

  components: {}

  data: ->
    loggedIn: @$root.$data.loggedIn

  ready: ->
    @$root.$watch 'loggedIn', (val) =>
      @$data.loggedIn = val

  methods:
    onClick: (e) ->
