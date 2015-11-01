class Route
  constructor: (@app, @crud, @cm, @models) ->
    entityAll    = @crud.entity('/users')
    entitySingle = @crud.entity('/users/:_id')
    Model        = @models.user

    entityAll.Create().pipe(@cm.createNew(Model))
    entityAll.Read().pipe(@cm.findAll(Model))
    entityAll.Delete().pipe(@cm.removeAll(Model))

    entitySingle.Read().pipe(@cm.findOne(Model))
    entitySingle.Update().pipe(@cm.updateOne(Model))
    entitySingle.Delete().pipe(@cm.removeOne(Model))

module.exports = Route
