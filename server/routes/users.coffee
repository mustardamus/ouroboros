bcrypt = require('bcrypt')
jwt    = require('jsonwebtoken')
auth   = require('../middleware/auth')
email  = require('../helpers/email')

class UsersRoute
  constructor: (@config, @app, @crud, @cm, @models, @io) ->
    @entityAll    = @crud.entity('/users')
    @entitySingle = @crud.entity('/users/:_id')

    @createUserRoute()
    @getUserRoute()
    @updateUserRoute()

    @loginUserRoute()
    @forgotPasswordRoute()
    @resetPasswordRoute()

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

  forgotPasswordRoute: ->
    @app.post '/api/forgot-password', (req, res, next) =>
      unless req.body.email
        return res.status(403).json({ message: 'Provide a e-mail address' })

      @models.user.findOne { email: req.body.email }, (err, user) =>
        if err or !user
          return res.status(403).json({ message: 'Can not find user with e-mail address' })

        now       = (new Date()).getTime()
        resetObj  = { userId: user._id, requestedAt: now }
        token     = jwt.sign(resetObj, @config.auth.secret, { expiresIn: @config.auth.resetTokenExpiresIn })
        port      = if req.hostname is 'localhost' then ":#{@config.server.port}" else ''
        resetLink = "#{req.protocol}://#{req.hostname}#{port}/#!/reset-password/#{token}"
        subject   = @config.messages.resetPasswordMailSubject
        emailText = @config.messages.resetPasswordMailText(resetLink)
        emailHtml = @config.messages.resetPasswordMailHtml(resetLink)

        email.sendTextHtml @config.mailgun.fromEmail, user.email, subject, emailText, emailHtml, (err) ->
          if err
            res.status(403).json({ message: 'Sending reset e-mail failed' })
          else
            res.json({ success: true })

  resetPasswordRoute: ->
    @app.post '/api/reset-password', (req, res, next) =>
      unless req.body.token
        return res.status(403).json({ message: 'Provide a reset token' })

      unless req.body.password
        return res.status(403).json({ message: 'Provide a new password' })

      jwt.verify req.body.token, @config.auth.secret, (err, decoded) =>
        return res.status(403).json({ message: 'Invalid token' }) if(err)

        @models.user.findById decoded.userId, (err, user) =>
          if err or !user
            return res.status(403).json({ message: 'User not found' })

          salt     = bcrypt.genSaltSync(@config.auth.saltLength)
          password = bcrypt.hashSync(req.body.password, salt)

          user.update { password: password }, (err) =>
            if err
              res.status(403).json({ message: 'Could not update password' })
            else
              res.json({ success: true })


module.exports = UsersRoute
