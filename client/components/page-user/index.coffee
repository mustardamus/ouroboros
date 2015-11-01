module.exports =
  replace:  true
  template: require('./template')

  components: {}

  data: ->
    entity: 'users'
    user  : { username: 'loading...' }

  ready: ->
    @$crud(@$route.params.id).read (err, user) =>
      @$data.user = user

  methods:
    onSubmit: ->
      obj = { username: @$data.user.username }

      @$crud(@$data.user._id).update obj, (err, user) =>
        @$data.user = user
