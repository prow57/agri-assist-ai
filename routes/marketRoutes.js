const express = require('express');
const router = express.Router();
const marketService = require('../services/marketService');
const authMiddleware = require('../middlewares/authMiddleware');

// Add a market (authenticated)
router.post('/add', authMiddleware, async (req, res) => {
    const { name, location } = req.body;
   
    try {
        const result = await marketService.createMarket(name, location);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get all markets (public)
router.get('/', async (req, res) => {
    try {
        const markets = await marketService.getAllMarkets();
        res.status(200).json(markets);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Update a market by ID (authenticated)
router.put('/edit/:id', authMiddleware, async (req, res) => {
    const { id } = req.params;
    const { name, location } = req.body;
    try {
        const updatedMarket = await marketService.updateMarket(id, name, location);
        res.status(200).json(updatedMarket);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Delete a market by ID (authenticated)
router.delete('/delete/:id', authMiddleware, async (req, res) => {
    const { id } = req.params;
    try {
        const isDeleted = await marketService.deleteMarket(id);
        if (isDeleted) {
            res.status(204).end(); // No content
        } else {
            res.status(404).json({ error: 'Market not found' });
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;
