module.exports =
  server:
    port: 9991
    paths:
      public: "#{__dirname}/../public"

  auth:
    saltLength: 10
    secret: '1234'

  database:
    url: 'mongodb://localhost/ouroboros'
