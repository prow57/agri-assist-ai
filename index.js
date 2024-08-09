require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const ussdRoutes = require('./routes/ussdRoutes');

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.urlencoded({ extended: true }));

// Test endpoint
app.get('/', (req, res) => {
    res.send('Test request is working');
});

// USSD Route
app.use('/ussd', ussdRoutes);

// Start the server
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});
