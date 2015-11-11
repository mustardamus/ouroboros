bcrypt = require('bcrypt')
jwt    = require('jsonwebtoken')
auth   = require('../middleware/auth')

class UsersRoute
  constructor: (@config, @app, @crud, @cm, @models, @io) ->
    @entityAll    = @crud.entity('/users')
    @entitySingle = @crud.entity('/users/:_id')
    Model        = @models.user

    @createUserRoute()
    @getUserRoute()

    @entityAll.Read().pipe(@cm.findAll(Model))
    @entityAll.Delete().pipe(@cm.removeAll(Model))

    @entitySingle.Update().pipe(@cm.updateOne(Model))
    @entitySingle.Delete().pipe(@cm.removeOne(Model))

  createUserRoute: ->
    @entityAll.Create()
      .pipe (data, query, cb) =>
        return cb({ message: 'Username must be provided' }) unless(data.username)
        return cb({ message: 'Password must be provided' }) unless(data.password)

        salt = bcrypt.genSaltSync(@config.auth.saltLength)

        cb null,
          username: data.username
          password: bcrypt.hashSync(data.password, salt)

      .pipe (data, query, cb) =>
        @models.user.count { username: data.username }, (err, count) ->
          return cb(err) if(err)
          return cb({ message: 'Username already exists.' }) if(count isnt 0)
          cb()

      .pipe (data, query, cb) =>
        user = new @models.user
          username: data.username
          password: data.password

        user.save (err) =>
          return cb(err) if(err)

          token = jwt.sign(user._id, @config.auth.secret)
          cb null, { token: token, userId: user._id }

  getUserRoute: ->
    @entitySingle.Read()
      .use auth(@config, @models)
      .pipe (data, query, cb) ->
        if query._id and query._id is 'me'
          cb null, data, { _id: @request.user._id }
        else
          cb()

      .pipe (data, query, cb) =>
        query.fields = 'username,createdAt'
        cb null, data, query

      .pipe @cm.findOne(@models.user)


module.exports = UsersRoute
