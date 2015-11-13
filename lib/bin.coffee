chalk = require('chalk')
argv  = require('yargs').argv
spawn = require('cross-spawn')

class OroBin
  printUsage: ->
    console.log """
    Usage: #{chalk.green('oro')} #{chalk.yellow('command')} [options]

    Commands:
      #{chalk.yellow('(n) new [project-name]')} - Create a new project
      #{chalk.yellow('(s) start')}                  - Start the development server
      #{chalk.yellow('(g) generate')}               - Generate from templates
      #{chalk.yellow('(p) pack')}                   - Pack the client app for production
      #{chalk.yellow('(t) test')}                   - Run the end2end tests (must run Selenimum Server via 'start')
    """

  constructor: ->
    return @printUsage() if(argv._.length is 0)

    lib = "#{process.cwd()}/lib"

    switch argv._[0]
      when 'new', 'n'
        unless argv._[1]
          console.log "#{chalk.red('Project-name missing:')} #{chalk.green('oro')} #{chalk.yellow('new')} #{chalk.red('?')}"
        else
          newProject = require("./newProject")
          new newProject(argv._[1])
      when 'start', 's'
        spawn.sync 'node', ['node_modules/foreman/nf.js', 'start'], { stdio: 'inherit' }
      when 'generate', 'g'
        require "#{lib}/generator"
      when 'pack', 'p'
        require "#{lib}/pack"
      when 'test', 't'
        spawn.sync 'node', ['node_modules/nightwatch/bin/nightwatch'], { stdio: 'inherit' }
      else
        console.log "#{chalk.red('Unknown Command:')} #{chalk.yellow(argv._[0])}\n"
        @printUsage()

module.exports = new OroBin
