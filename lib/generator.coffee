fs        = require('fs-extra')
_         = require('lodash')
hogan     = require('hogan.js')
inquirer  = require('inquirer')
chalk     = require('chalk')
async     = require('async')
config    = require('../config')
templates = require("#{config.paths.templates}")

class Generator
  constructor: ->
    compFlat = []

    for component, obj of templates
      compFlat.push { name: component, message: component }

    inquirer.prompt
      name   : 'componentType'
      message: 'What to generate?'
      choices: compFlat
      type   : 'list'
    , (answer) =>
      variables = []
      template  = templates[answer.componentType]
      files     = template.files

      for inPath, outPath of files
        content = fs.readFileSync("#{config.paths.templates}/#{inPath}", 'utf8')

        variables.push @extractVariables(content)
        variables.push @extractVariables(outPath)

      @requestVariables template, _.unique(_.flatten(variables)), @buildTemplates

  extractVariables: (content) ->
    variables = []
    cutOut    = ->
      return(false) if(content.indexOf('^^') is -1)

      name    = content.split('^^')[0]
      content = content.substr(name.length + 2)
      content = content.substr(content.indexOf('^^') + 2)

      variables.push name

    content = content.substr(content.indexOf('^^') + 2)
    while cutOut() then -> # funky baby
    variables

  requestVariables: (template, variables, cb) ->
    funcsArr = []

    for variable in variables
      do (variable) =>
        funcsArr.push (cb) =>
          inquirer.prompt { name: variable, message: variable, }, (answer) =>
            cb null, { name: variable, answer: answer[variable] }

    async.series funcsArr, (err, result) =>
      obj = {}

      for variable in result
        obj[variable.name] = variable.answer

      cb null, template, obj

  buildTemplates: (err, templateObj, data) ->
    for inPath, outPath of templateObj.files
      inContent = fs.readFileSync("#{config.paths.templates}/#{inPath}", 'utf8')
      template  = hogan.compile(inContent, { delimiters: '^^ ^^' })
      pathTemp  = hogan.compile(outPath, { delimiters: '^^ ^^' })
      outFile   = pathTemp.render(data)
      compiled  = template.render(data)
      outPath   = "#{__dirname}/../#{outPath}"

      fs.ensureDirSync _.dropRight(outFile.split('/')).join('/')
      fs.writeFileSync outFile, compiled, 'utf8'

      console.log "#{chalk.yellow('./templates/')}#{inPath}", chalk.yellow('->'), "#{chalk.yellow('./')}#{outFile}"


module.exports = new Generator
