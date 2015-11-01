module.exports =
  replace:  true
  template: require('./template')

  components: {}

  data: ->
    users   : []
    username: ''

  ready: ->
    @$crud('/users').read (err, users) =>
      @$data.users = users

  methods:
    onSubmit: ->
      obj = { username: @$data.username }

      @$crud('/users').create obj, (err, user) =>
        @$data.users.push user
        @$data.username = ''

    onDelete: (id) ->
      @$crud("/users/#{id}").del (err, res) =>
        @$data.users = _.remove @$data.users, (user) ->
          user._id isnt id
