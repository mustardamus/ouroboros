path         = require('path')
fs           = require('fs-extra')
browserify   = require('browserify')
stylus       = require('stylus')
autoprefixer = require('autoprefixer')
postcss      = require('postcss')
config       = require('./config')

class Build
  constructor: ->
    @scriptBundle = browserify(config.browserify.options)
      .add("#{config.paths.client}/#{config.browserify.entry}")

    for transform in config.browserify.transforms
      @scriptBundle.transform(require(transform))

  html: (cb) ->
    inPath  = "#{config.paths.client}/#{config.html.entry}"
    outPath = "#{config.paths.public}/#{config.html.output}"

    fs.ensureDirSync config.paths.public

    fs.copy inPath, outPath, (err) ->
      if err
        cb(err)
      else
        cb(null, outPath)

  libs: (cb) ->
    inPath  = "#{config.paths.client}/#{config.browserify.entry}"
    outPath = "#{config.paths.public}/libs.js"
    content = fs.readFileSync(inPath, 'utf8')
    libsArr = []

    fs.ensureDirSync config.paths.public

    for global in content.split('global ')
      libPath = global.split('\n')[0]
      libPath = path.join(config.paths.client, libPath)

      if fs.existsSync(libPath)
        libsArr.push fs.readFileSync(libPath, 'utf8')

    fs.writeFileSync outPath, libsArr.join(';\n'), 'utf8'
    cb null, outPath

  script: (cb) ->
    outPath = "#{config.paths.public}/#{config.browserify.output}"
    stream  = fs.createWriteStream(outPath)

    fs.ensureDirSync config.paths.public
    stream.on('close', -> cb(null, outPath))

    @scriptBundle.bundle()
      .on('error', (err) -> cb(err))
      .pipe(stream)

  style: (cb) ->
    inPath  = "#{config.paths.client}/#{config.stylus.entry}"
    outPath = "#{config.paths.public}/#{config.stylus.output}"
    styl    = fs.readFileSync(inPath, 'utf8')

    fs.ensureDirSync config.paths.public

    stylus(styl)
      .set('filename', config.stylus.output)
      .set('paths', [config.paths.client])
      .set('include css', true)
      .render (err, css) ->
        if(err)
          cb(err)
        else
          postcss([autoprefixer]).process(css).then (result) ->
            fs.writeFileSync outPath, result.css, 'utf8'
            cb(null, outPath)

  font: (cb) ->
    inPath = "#{__dirname}/../#{config.font.entry}"
    outPath = "#{config.paths.public}/#{config.font.output}"

    fs.ensureDirSync config.paths.public

    fs.copy inPath, outPath, (err) ->
      if err
        cb(err)
      else
        cb(null, outPath)


module.exports = new Build
