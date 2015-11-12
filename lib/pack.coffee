fs     = require('fs-extra')
uglify = require('uglify-js')
csso   = require('csso')
chalk  = require('chalk')
build  = require('./build')

class Pack
  constructor: ->
    for type in ['html', 'font']
      @build type

    for type in ['libs', 'script', 'style']
      @compress type

  build: (type) ->
    build[type] (err, path) ->
      if err
        console.log chalk.red(err)
      else
        console.log "#{chalk.green('Compiled')} #{chalk.yellow(path)}"

  compress: (type) ->
    build[type] (err, path) ->
      if err
        console.log chalk.red(err)
      else
        minified = ''

        switch type
          when 'script', 'libs'
            minified = uglify.minify(path).code
          when 'style'
            css      = fs.readFileSync path, 'utf8'
            minified = csso.minify(css)

        fs.unlinkSync path
        fs.writeFileSync path, minified, 'utf8'

        console.log "#{chalk.green('Minified')} #{chalk.yellow(path)}"


module.exports = new Pack
