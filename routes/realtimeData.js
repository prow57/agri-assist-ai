// routes/realtimeData.js
const express = require('express');
const db = require('../firebase');
const router = express.Router();

router.get('/leaf-scans', async (req, res) => {
    try {
        const snapshot = await db.collection('leafScans').orderBy('timestamp', 'desc').get();
        const data = snapshot.docs.map(doc => doc.data());
        res.json(data);
    } catch (error) {
        res.status(500).send(error.message);
    }
});

router.get('/soil-detections', async (req, res) => {
    try {
        const snapshot = await db.collection('soilDetections').orderBy('timestamp', 'desc').get();
        const data = snapshot.docs.map(doc => doc.data());
        res.json(data);
    } catch (error) {
        res.status(500).send(error.message);
    }
});

module.exports = router;
