module.exports = ->
  menuItems   : []                # generated based on routes
  loggedIn    : false             # determines if a user is logged in
  currentToken: null              # token of the logged in user
  currentUser :                   # information for current user
    username: ''
    email   : ''
