const express = require('express');
require('dotenv').config();
const db = require('./db');
const bodyParser = require('body-parser');
const routes = require('./routes');
const healthRoutes = require('./routes/healthRoutes');
const cropPriceRoutes = require('./routes/cropPriceRoutes');
const userRoutes = require('./routes/userRoutes'); 

const app = express();

// Test the connection
db.connect()
  .then(obj => {
    obj.done(); // success, release the connection;
    console.log("PostgreSQL connection successful");
  })
  .catch(error => {
    console.log("Error connecting to PostgreSQL:", error);
  });

// Middleware setup
app.use(bodyParser.json());
app.use(express.json());

// Route setup
app.use('/api', routes);
app.use('/api/health', healthRoutes);
app.use('/api/crop-prices', cropPriceRoutes);
app.use('/api/users', userRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
