fs         = require('fs')
browserify = require('browserify')
stylus     = require('stylus')
config     = require('../config')

class Build
  constructor: ->
    @scriptBundle = browserify(config.browserify.options)
      .add("#{config.paths.client}/#{config.browserify.entry}")

    for transform in config.browserify.transforms
      @scriptBundle.transform(require(transform))

  html: (cb) ->
    inPath  = "#{config.paths.client}/#{config.html.entry}"
    outPath = "#{config.paths.public}/#{config.html.output}"

    fs.createReadStream(inPath)
      .on('end', -> cb(null, outPath))
      .pipe(fs.createWriteStream(outPath))

  script: (cb) ->
    path   = "#{config.paths.public}/#{config.browserify.output}"
    stream = fs.createWriteStream(path)

    @scriptBundle.bundle()
      .on('end', -> cb(null, path))
      .on('error', (err) -> cb(err))
      .pipe(stream)

  style: (cb) ->
    inPath  = "#{config.paths.client}/#{config.stylus.entry}"
    outPath = "#{config.paths.public}/#{config.stylus.output}"
    styl    = fs.readFileSync(inPath, 'utf8')

    stylus.render styl, (err, css) =>
      if(err)
        cb(err)
      else
        fs.writeFileSync outPath, css, 'utf8'
        cb(null, outPath)


module.exports = new Build
