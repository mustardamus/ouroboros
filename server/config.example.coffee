module.exports =
  server:
    port : 9991
    paths:
      public: "#{__dirname}/../public"

  auth:
    saltLength         : 10
    secret             : '1234'
    resetTokenExpiresIn: '30m'

  database:
    url: 'mongodb://localhost/ouroboros'

  mailgun:
    domain   : null
    apiKey   : null
    fromEmail: 'our@oboros.com'

  messages:
    resetPasswordMailSubject: 'Reset Password'
    resetPasswordMailText: (resetLink) ->
      "Hey! You've requested to reset your password. Please follow the link below to do so: \n\n#{resetLink}"
    resetPasswordMailHtml: (resetLink) ->
      "Hey! You've requested to reset your password. Please <a href='#{resetLink}'>follow this link</a> to do so."
