module.exports =
  replace:  true
  template: require('./template')

  components: {}

  data: ->
    entity  : 'users'
    users   : []
    username: ''

  ready: ->
    @$crud().read (err, users) =>
      @$data.users = users

  methods:
    onSubmit: ->
      obj = { username: @$data.username }

      @$crud().create obj, (err, user) =>
        @$data.users.push user
        @$data.username = ''

    onDelete: (id) ->
      @$crud(id).del (err, res) =>
        @$data.users = _.remove @$data.users, (user) ->
          user._id isnt id
