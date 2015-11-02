express    = require('express')
bodyParser = require('body-parser')

module.exports = (config) ->
  @use express.static(config.server.paths.public)
  @use bodyParser.urlencoded({ extended: true })
  @use bodyParser.json()
