_          = require('lodash')
express    = require('express')
crud       = require('node-crud')
mongoose   = require('mongoose')
cm         = require('crud-mongoose')
glob       = require('glob')
chalk      = require('chalk')

class Server
  constructor: ->
    chalk.enabled = true

    @app = express()

    @inits  = @dirToHash("#{__dirname}/initialize/*.coffee")
    @models = @dirToHash("#{__dirname}/models/*.coffee")
    @routes = @dirToHash("#{__dirname}/routes/*.coffee")

    @initialize()
    @start()

  initialize: ->
    for name, func of @inits
      func.call @app

    for name, func of @models
      @models[name] = func.call(mongoose)

    for name, func of @routes
      new func(@app, crud, cm, @models)

  start: ->
    mongoose.connect 'mongodb://localhost/ouroboros'
    crud.launch(@app)
    @app.listen(9991)
    console.log 'Lets roll'

  dirToHash: (path) ->
    outObj = {}
    files  = glob.sync(path)

    for file in files
      name         = _.last(file.split('/')).split('.')[0]
      outObj[name] = require(file)

      console.log "#{chalk.green('Initialized')} #{chalk.yellow(file)}"

    outObj


module.exports = new Server
