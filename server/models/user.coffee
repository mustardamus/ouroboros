module.exports = (helpers) ->
  Schema = new @Schema
    username: { type: String, required: true }
    password: { type: String }
    email   : { type: String }
    admin   : { type: Boolean, default: false }
  ,
    timestamps: true

  @model 'User', Schema
