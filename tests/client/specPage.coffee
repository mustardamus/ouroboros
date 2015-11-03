module.exports =
  'Home Page' : (client) ->
    client
      .url('http://localhost:9991')
      .waitForElementVisible('body', 1000)
      .assert.title('Ouroboros')
      .end()
