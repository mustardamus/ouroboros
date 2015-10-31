fs          = require('fs')
_           = require('lodash')
browserSync = require('browser-sync').create()
chalk       = require('chalk')
build       = require('./build')
config      = require('../config')

class DevServer
  constructor: ->
    _.bindAll @, 'onClientFileChange'

    chalk.enabled = true

    @watchPublicFiles = [
      "#{config.paths.public}/#{config.html.output}"
      "#{config.paths.public}/#{config.browserify.output}"
      "#{config.paths.public}/#{config.stylus.output}"
    ]

    @watchClientFiles = [
      "#{config.paths.client}/**/*.coffee"
      "#{config.paths.client}/**/*.styl"
      "#{config.paths.client}/**/*.html"
    ]

    @browserSyncStart()

    browserSync.watch(@watchClientFiles).on 'all', @onClientFileChange

  build: (type) ->
    build[type] (err, path) ->
      if err
        console.log chalk.red(err)
      else
        browserSync.reload(path)

  browserSyncStart: ->
    bsConfig = _.extend {}, config.browserSync.options,
      port : config.devServer.port
      proxy: "localhost:#{config.server.port}"
      files: @watchPublicFiles

    browserSync.init bsConfig

  onClientFileChange: (event, path) ->
    if path is "#{config.paths.client}/index.html"
      @build 'html'
    else
      extension = _.last(path.split('/')).split('.')[1]

      switch extension
        when 'coffee', 'html' then @build 'script'
        when 'styl'           then @build 'style'

module.exports = new DevServer
