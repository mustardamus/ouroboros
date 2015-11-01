Start Express/CRUD and Development Server with Foreman

    npm start

Define third party libs that are loaded as globals in ./client/index.coffee like
so:

    ###
    global ../node_modules/vue/dist/vue.js
    ###

window.Vue is then defined, for example. This makes building the bundle with
browserify a billion times faster.
