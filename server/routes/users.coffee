bcrypt = require('bcrypt')
jwt    = require('jsonwebtoken')
auth   = require('../middleware/auth')

class UsersRoute
  constructor: (@config, @app, @crud, @cm, @models, @io) ->
    @entityAll    = @crud.entity('/users')
    @entitySingle = @crud.entity('/users/:_id')

    @createUserRoute()
    @getUserRoute()
    @updateUserRoute()
    @loginUserRoute()

    #@entityAll.Read().pipe(@cm.findAll(Model))
    #@entityAll.Delete().pipe(@cm.removeAll(Model))

    #@entitySingle.Delete().pipe(@cm.removeOne(Model))

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
          return cb({ message: 'Username already exists' }) if(count isnt 0)
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
        query.fields = 'username,email,createdAt,updatedAt'
        cb()
      .pipe @cm.findOne(@models.user)

  updateUserRoute: ->
    self = @

    @entitySingle.Update()
      .use auth(@config, @models)
      .pipe (data, query, cb) ->
        if query._id and query._id is 'me'
          cb null, data, { _id: @request.user._id }
        else
          unless @request.user.admin
            cb { message: 'You can only update your own account' }
          else
            cb()
      .pipe (data, query, cb) ->
        if data.username and data.username isnt @request.user.username
          self.models.user.count { username: data.username }, (err, count) =>
            if(err or count isnt 0)
              cb({ message: 'Username already exists' })
            else
              cb()
        else
          cb()
      .pipe @cm.updateOne(@models.user)
      .pipe (data, query, cb) ->
        query.fields = 'username,email,createdAt,updatedAt'
        cb()
      .pipe @cm.findOne(@models.user)

  loginUserRoute: ->
    @app.post '/api/login', (req, res, next) =>
      unless req.body.username
        return res.status(403).json({ message: 'Provide a username' })

      unless req.body.password
        return res.status(403).json({ message: 'Provide a password' })

      @models.user.findOne { username: req.body.username }, (err, user) =>
        if err or !user
          res.status(403).json({ message: 'Error finding user to log in' })
        else
          unless bcrypt.compareSync(req.body.password, user.password)
            res.status(403).json({ message: 'Wrong password' })
          else
            res.json({ token: jwt.sign(user._id, @config.auth.secret) })


module.exports = UsersRoute
