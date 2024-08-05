const express = require('express');
const bodyParser = require('body-parser');
const routes = require('./routes');
const healthRoutes = require('./routes/healthRoutes');
require('dotenv').config();

const app = express();

app.use(bodyParser.json());
app.use(express.json);
app.use('/api', routes);
app.use('/api/health', healthRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
