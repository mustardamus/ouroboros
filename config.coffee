module.exports =
  paths:
    client: "#{__dirname}/client" # client framework and files
    public: "#{__dirname}/public" # compiled files from client
    server: "#{__dirname}/server" # server framework and files

  devServer:
    port: 9990 # served by browser-sync

  browserSync:
    options: # extended initial options
      notify        : false
      open          : false

  server:
    port: 9991 # will be proxied by devServer on localhost

  browserify: # builds the script entry of the app
    entry     : 'index.coffee' # in client directory
    output    : 'bundle.js' # in public directory
    transforms: [ # applied transforms
      'coffeeify'
      'html2js-browserify'
      'require-globify'
    ]
    options   : # initial options
      fullPaths    : false
      extensions   : ['.coffee', '.html']

  stylus: # builds the style entry of the app
    entry: 'index.styl' # in client directory
    output: 'bundle.css' # in public directory

  html: # copys the main html entry of the app
    entry: 'index.html' # in client directory
    output: 'index.html' # in public directory

  font: # copys fontawesome files
    entry: 'bower_components/semantic/dist/themes' # in root directory
    output: 'themes' # in public directory
