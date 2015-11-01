module.exports =
  replace:  true
  template: require('./template')

  components: {}

  data: ->

  ready: ->
    @$crud('/users').read (err, users) ->
      console.log err, users

  methods:
    onClick: (e) ->
