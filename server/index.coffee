http     = require('http')
_        = require('lodash')
express  = require('express')
crud     = require('node-crud')
mongoose = require('mongoose')
cm       = require('crud-mongoose')
glob     = require('glob')
chalk    = require('chalk')
socket   = require('socket.io')
config   = require('./config')

class Server
  constructor: ->
    chalk.enabled = true

    @app    = express()
    @server = http.Server(@app)
    @io     = socket(@server)
    @inits  = @dirToHash("#{__dirname}/initialize/*.coffee")
    @models = @dirToHash("#{__dirname}/models/*.coffee")
    @routes = @dirToHash("#{__dirname}/routes/*.coffee")

    @initialize()
    @start()

  initialize: ->
    for name, func of @inits
      func.call @app, config

    for name, func of @models
      @models[name] = func.call(mongoose)

    for name, func of @routes
      new func(config, @app, crud, cm, @models, @io)

  start: ->
    port  = config.server.port
    dbUrl = config.database.url
    db    = mongoose.connection

    db.on 'open', ->
      console.log "#{chalk.green('Database connected')} #{chalk.yellow(dbUrl)}"

    mongoose.connect dbUrl

    @io.on 'connection', (socket) ->
      console.log "#{chalk.green('Socket connected')} #{chalk.yellow(socket.id)}"

    crud.launch @app

    @server.listen port, ->
      console.log "#{chalk.green('Server started on port')} #{chalk.yellow(port)}"

  dirToHash: (path) ->
    outObj = {}
    files  = glob.sync(path)

    for file in files
      name         = _.last(file.split('/')).split('.')[0]
      outObj[name] = require(file)

      console.log "#{chalk.green('Initialized')} #{chalk.yellow(file)}"

    outObj


module.exports = new Server
