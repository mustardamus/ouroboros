chalk = require('chalk')
argv  = require('yargs').argv

class OroBin
  printUsage: ->
    console.log """
    Usage: #{chalk.green('oro')} #{chalk.yellow('command')} [options]

    Commands:
      #{chalk.yellow('(n) new')}          - Create a new project
      #{chalk.yellow('(s) start')}        - Start the development server
      #{chalk.yellow('(g) generate')} - Generate from templates
      #{chalk.yellow('(p) pack')}         - Pack the client app for production
    """

  constructor: ->
    return @printUsage() if(argv._.length is 0)

    lib = "#{process.cwd()}/lib"

    switch argv._[0]
      when 'new', 'n'
        console.log 'new'
      when 'start', 's'
        require "#{lib}/devServer"
      when 'generate', 'g'
        require "#{lib}/generator"
      when 'pack', 'p'
        require "#{lib}/pack"
      else
        console.log "Unknown Command: #{chalk.yellow(argv._[0])}\n"
        @printUsage()

module.exports = new OroBin
