// db.js
const pgp = require('pg-promise')();
const connectionString = process.env.PG_CONNECTION_STRING;

if (!connectionString) {
    throw new Error('PG_CONNECTION_STRING is not set in the environment variables');
  }

const db = pgp(connectionString);

module.exports = db;
