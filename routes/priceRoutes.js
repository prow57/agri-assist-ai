const express = require('express');
const router = express.Router();
const priceController = require('../controllers/priceController');
const authMiddleware = require('../middlewares/authMiddleware');

// Add a price (authenticated)
router.post('/add', authMiddleware, async (req, res) => {
    const { product_id, market_id, price } = req.body;
    try {
        const result = await priceController.addPrice(req, res); // Delegate to controller
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get all prices (public)
router.get('/', async (req, res) => {
    try {
        const prices = await priceController.getPrices(req, res); // Delegate to controller
        res.status(200).json(prices);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Update a price by ID (authenticated)
router.put('/edit/:id', authMiddleware, async (req, res) => {
    const { id } = req.params;
    const { product_id, market_id, price } = req.body;
    try {
        const updatedPrice = await priceController.updatePrice(req, res); // Delegate to controller
        res.status(200).json(updatedPrice);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Delete a price by ID (authenticated)
router.delete('/delete/:id', authMiddleware, async (req, res) => {
    const { id } = req.params;
    try {
        const isDeleted = await priceController.deletePrice(req, res); // Delegate to controller
        if (isDeleted) {
            res.status(204).end(); // No content
        } else {
            res.status(404).json({ error: 'Price not found' });
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;
