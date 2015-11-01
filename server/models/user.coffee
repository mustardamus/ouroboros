module.exports = ->
  Schema = new @Schema
    username: { type: String, required: true }
    created : { type: Date, default: Date.now }

  @model('User', Schema)
