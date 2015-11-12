fs           = require('fs')
path         = require('path')
_            = require('lodash')
browserSync  = require('browser-sync').create()
chalk        = require('chalk')
async        = require('async')
build        = require('./build')
config       = require('./config')
serverConfig = require('../server/config.coffee')

class DevServer
  constructor: ->
    _.bindAll @, 'onClientFileChange'

    chalk.enabled = true

    @watchClientFiles = [
      "#{path.join(config.paths.client)}/**/*.coffee"
      "#{path.join(config.paths.client)}/**/*.styl"
      "#{path.join(config.paths.client)}/**/*.html"
    ]

    @initialBuild =>
      @browserSyncStart()
      @watchClientFileChanges()

  build: (type, cb = ->) ->
    build[type] (err, path) ->
      if err
        console.log chalk.red(err)
      else
        browserSync.reload(path)
        console.log "#{chalk.green("Compiled")} #{chalk.yellow(path)}"

      cb()

  initialBuild: (cb) ->
    funcsArr = []

    for type in ['libs', 'html', 'script', 'style', 'font']
      do (type) =>
        funcsArr.push (cb) =>
          @build type, cb

    async.series funcsArr, cb

  browserSyncStart: ->
    bsConfig = _.extend {}, config.browserSync.options,
      port : config.devServer.port
      proxy: { target: "localhost:#{serverConfig.server.port}", ws: true }

    browserSync.init bsConfig

  watchClientFileChanges: ->
    debouncedFunc = _.debounce(@onClientFileChange, 100)

    browserSync.watch(@watchClientFiles).on 'all', debouncedFunc

  onClientFileChange: (event, path) ->
    switch path
      when "#{config.paths.client}/#{config.html.entry}"
        @build('html')
      when "#{config.paths.client}/#{config.browserify.entry}"
        @build('libs')
      else
        extension = _.last(path.split('/')).split('.')[1]

        switch extension
          when 'coffee', 'html' then @build('script')
          when 'styl'           then @build('style')


module.exports = new DevServer
