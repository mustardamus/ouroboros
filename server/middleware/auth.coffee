jwt = require('jsonwebtoken')

module.exports = (config, models) ->
  return (req, res, next) ->
    token = req.body.token or req.query.token

    unless token
      return res.status(403).send({ message: 'No auth token provided' })

    jwt.verify token, config.auth.secret, (err, userId) =>
      return res.status(403).send({ message: 'Invalid auth token' }) if(err)

      models.user.findById userId, (err, user) =>
        if err
          res.status(403).send({ message: 'Error finding current user' })
        else
          req.user = user
          next()
