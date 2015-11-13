## Ouroboros Framework

Ouroboros is a collection of various JavaScript tools and frameworks which aims
to speed up developing Singe Page Applications. The application comes with a
user registration and login system.

## `oro` Commands

First install Ouroboros globally to have access to the `oro` application:

    npm install -g ouroboros

Or get the latest code and link it:

    git clone https://github.com/mustardamus/ouroboros.git
    cd ouroboros
    npm install
    npm link

### `oro new` (`oro n`) - Create a new application

### `oro start` (`oro s`) - Start the development server

Using [Foreman](https://github.com/strongloop/node-foreman), it starts several
processes at once (see `./Procfile`):

- `mongod` - Start [MongoDB](https://www.mongodb.org/).
- `java -jar ./lib/selenium-server-standalone-2.48.2.jar` - Start a Standalone
  Selenium Server to be used by [Nightwatch](http://nightwatchjs.org/guide) for
  the end2end testing.
- `node ./node_modules/forever/bin/forever -c coffee -f -m 3 --watch --watchDirectory="server" server/index.coffee` -
  Start the [Express.js](expressjs.com) server located in `./server`
  with [Forever](https://github.com/foreverjs/forever). Every time the code in
  `./server` changes, the server will be restarted. Default port is 9991.
- `node ./node_modules/forever/bin/forever -c coffee -f -m 3 --watch --watchDirectory="lib" lib/devServer.coffee` -
  Start the [BrowserSync](http://www.browsersync.io/) development server. Every
  time code in `./client` changes, the application is freshly bundled and the
  browser reloads. Every time code in `./lib` changes, the development server is
  restarted. Default port is 9990.

### `oro generate` (`oro g`) - Generate components from templates
### `oro pack` (`oro p`) - Back the application files for production
### `oro test` (`oro t`) - Run the end2end tests

Start Express/CRUD and Development Server with Foreman

    npm start

Minify Script and style

    npm run-script pack

Define third party libs that are loaded as globals in ./client/index.coffee like
so:

    ###
    global ../node_modules/vue/dist/vue.js
    ###

window.Vue is then defined, for example. This makes building the bundle with
browserify a billion times faster.

To exclude a global script, but still have the path available, just make then
path invalid, with a # for example:

    global #../bower_components/semantic/dist/components/accordion.js

## Generate Top Navigation dynamically

If you set a menu param to a route, it will be automatically included in the Top
navigation:

    '/users':
      name: 'users'
      component: require('../components/page-users')
      params:
        menu: { name: 'All Users', icon: 'users' }

## Run all Tests

This will load the /tests/index.js file with will expand the test case with every
spec*.coffee, can also be in a subdirectory.

    npm install nightwatch -g
    nightwatch
