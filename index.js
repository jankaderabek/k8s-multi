'use strict';
Promise = require('bluebird');
const config = require('./config');
const express = require('express');
const helmet = require('helmet');
const bodyParser = require('body-parser');
const logger = require("morgan");
var cors = require('cors')

const routes = require('./routes');
const errors = require('./errors/middleware');

const app = express();

// basic middleware
app.use(cors())
app.use(helmet());
app.use(logger(config.node_env === "production" ? "combined" : "dev"));
app.use(bodyParser.json());

// api routes
app.use('/api', routes)

// error middleware
app.use(errors)

app.all("*", (req, res) => res.status(200).send("My Node.js API"));

app.listen(config.port, '0.0.0.0', () => {
  console.log(`Server listening on port ${config.port}...`)
});
