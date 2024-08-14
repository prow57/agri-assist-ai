const express = require('express');
require('dotenv').config();
const db = require('./db');
const bodyParser = require('body-parser');
const routes = require('./routes');
const healthRoutes = require('./routes/healthRoutes');
const cropPriceRoutes = require('./routes/cropPriceRoutes');
const marketRoutes = require('./routes/marketRoutes');
const priceRoutes = require('./routes/priceRoutes');
const userRoutes = require('./routes/userRoutes'); 
const path = require('path');

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

// Serve static files from the 'public' directory
app.use(express.static(path.join(__dirname, 'public')));

// Route setup
app.use('/api', routes);
app.use('/api/health', healthRoutes);
app.use('/api/crop-prices', cropPriceRoutes);
app.use('/api/users', userRoutes);
app.use('/api/markets', marketRoutes);
app.use('/api/prices', priceRoutes); 

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
