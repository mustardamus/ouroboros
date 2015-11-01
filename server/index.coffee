express    = require('express')
bodyParser = require('body-parser')
crud       = require('node-crud')
mongoose   = require('mongoose')
cm         = require('crud-mongoose')

Schema = new mongoose.Schema
  username: { type: String, required: true }
  created : { type: Date, default: Date.now }

Model = mongoose.model('users', Schema)

app = express()

app.use express.static("#{__dirname}/../public")
app.use bodyParser.urlencoded({ extended: true })
app.use bodyParser.json()

crud.entity('/users').Create()
  .pipe(cm.createNew(Model));

crud.entity('/users').Read()
  .pipe(cm.findAll(Model))

crud.entity('/users').Delete()
    .pipe(cm.removeAll(Model));

crud.entity('/users/:_id').Read()
  .pipe(cm.findOne(Model))

crud.entity('/users/:_id').Update()
  .pipe(cm.updateOne(Model));

crud.entity('/users/:_id').Delete()
  .pipe(cm.removeOne(Model));

mongoose.connect 'mongodb://localhost/ouroboros'

crud.launch(app)
app.listen(9991)
console.log 'Lets roll'
