fs     = require('fs-extra')
chalk  = require('chalk')
spawn  = require('cross-spawn')
needle = require('needle')

class NewProject
  files: [
    'client'
    'lib'
    'server'
    'templates'
    'tests'
    '.gitignore'
    'bower.json'
    'nightwatch.json'
    'package.json'
    'Procfile'
    'README.md'
  ]

  constructor: (name) ->
    cwd          = process.cwd()
    rootDir      = "#{__dirname}/.."
    projectPath  = "#{cwd}/#{name}"
    seleniumUrl  = 'https://selenium-release.storage.googleapis.com/2.48/selenium-server-standalone-2.48.2.jar'
    seleniumPath = "#{projectPath}/lib/selenium-server-standalone-2.48.2.jar"

    if fs.existsSync(projectPath)
      console.log "#{chalk.yellow(name)} #{chalk.red('already exists')}"
      return
    else
      fs.mkdirSync "#{cwd}/#{name}"
      console.log "#{chalk.green('Created')} #{chalk.yellow(name)}"

    for file in @files
      fs.copySync "#{rootDir}/#{file}", "#{cwd}/#{name}/#{file}"
      console.log "#{chalk.green('Created')} #{chalk.yellow(name + '/' + file)}"

    console.log "#{chalk.green('Installing')} #{chalk.yellow('npm + bower')}"
    spawn.sync "npm", ['install'], { cwd: projectPath, stdio: 'inherit' }
    spawn.sync "bower", ['install'], { cwd: projectPath, stdio: 'inherit' }

    console.log "#{chalk.green('Downloading')} #{chalk.yellow('Selenium Standalone Server')}"
    needle.get seleniumUrl, { output: seleniumPath }, (err, res, body) ->
      console.log "#{chalk.green(':)')}"

module.exports = NewProject
