module.exports =
  template: require('./template')
  data    : require('./data')

  ready: ->
    console.log @$route

  methods: {}
