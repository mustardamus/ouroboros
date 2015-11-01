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
