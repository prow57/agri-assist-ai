// app.js
const express = require('express');
const app = express();
const leafScanRouter = require('./routes/leafScan');
const soilDetectionRouter = require('./routes/soilDetection');
const realtimeDataRouter = require('./routes/realtimeData');

app.use(express.json());
app.use('/api/leaf-scan', leafScanRouter);
app.use('/api/soil-detection', soilDetectionRouter);
app.use('/api/realtime-data', realtimeDataRouter);

app.get('/', (req, res) => {
    res.send('Welcome to the AI-driven Agricultural Advisory System');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
