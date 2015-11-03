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
