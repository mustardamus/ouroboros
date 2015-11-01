express    = require('express')
bodyParser = require('body-parser')

module.exports = ->
  @use express.static("#{__dirname}/../public")
  @use bodyParser.urlencoded({ extended: true })
  @use bodyParser.json()
