module.exports = ->
  Schema = new @Schema
    name: { type: String, required: true }
  ,
    timestamps: true

  @model('^^entityNameCapitalizeSingular^^', Schema)
