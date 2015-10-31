express    = require('express')
bodyParser = require('body-parser')
crud       = require('node-crud')
mongoose   = require('mongoose')
cm         = require('crud-mongoose')

Schema = new mongoose.Schema
  firstName: { type: String, required: true }
  lastName:  { type: String, required: true }
  gender:    { type: String, required: true, enum: ['M', 'F'] }
  created:   { type: Date, default: Date.now }

Model = mongoose.model('users', Schema)

app = express()

app.use express.static("#{__dirname}/../public")
app.use bodyParser.urlencoded({ extended: true })
app.use bodyParser.json()

crud
  .entity('/users')
  .Read()
  .pipe (data, query, cb) ->
    cb(null, [ { name: 'bobby tables' } ])

crud.launch(app)
app.listen(9991)
console.log 'Lets roll'

###
var crud = require('crud'),
  cm = require('crud-mongoose'),
  mongoose = require('mongoose'),
  Model = mongoose.model('users', new mongoose.Schema({
      firstName: { type: String, required: true },
      lastName:  { type: String, required: true },
      gender:    { type: String, required: true, enum: ['M', 'F'] },
      created:   { type: Date, default: Date.now }
  }));

// All Users -------------------------------------------------------------------

crud.entity('/users').Create()
  .pipe(cm.createNew(Model));

crud.entity('/users').Read()
  .pipe(cm.findAll(Model))

crud.entity('/users').Delete()
    .pipe(cm.removeAll(Model));

// One User --------------------------------------------------------------------

crud.entity('/users/:_id').Read()
  .pipe(cm.findOne(Model))

crud.entity('/users/:_id').Update()
  .pipe(cm.updateOne(Model));

crud.entity('/users/:_id').Delete()
  .pipe(cm.removeOne(Model));
  ###
