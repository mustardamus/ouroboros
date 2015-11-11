class ^^entityNameCapitalizePlural^^Route
  constructor: (@config, @app, @crud, @cm, @models, @io) ->
    entityAll    = @crud.entity('/^^entityNamePlural^^')
    entitySingle = @crud.entity('/^^entityNamePlural^^/:_id')
    Model        = @models.^^entityNameSingular^^

    entityAll.Create().pipe(@cm.createNew(Model))
    entityAll.Read().pipe(@cm.findAll(Model))
    entityAll.Delete().pipe(@cm.removeAll(Model))

    entitySingle.Read().pipe(@cm.findOne(Model))
    entitySingle.Update().pipe(@cm.updateOne(Model))
    entitySingle.Delete().pipe(@cm.removeOne(Model))

module.exports = ^^entityNameCapitalizePlural^^Route
