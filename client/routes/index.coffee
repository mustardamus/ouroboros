module.exports = ->
  outObj = {}

  for n, routeObj of require('./*.coffee', { mode: 'hash' })
    if typeof routeObj isnt 'function' # not this file
      for routePath, routeData of routeObj
        outObj[routePath] = routeData

  outObj
