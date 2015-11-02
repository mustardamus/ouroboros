module.exports =
  server:
    port: 9991
    paths:
      public: "#{__dirname}/../public"

  database:
    url: 'mongodb://localhost/ouroboros'
