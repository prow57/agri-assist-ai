const express = require('express');
const { addCropPrice, getCropPrices } = require('../services/cropPriceService');
const authMiddleware = require('../middlewares/authMiddleware');

const router = express.Router();

// Add a crop price (authenticated)
router.post('/add', authMiddleware, async (req, res) => {
  const { crop_name, price } = req.body;
  try {
    const result = await addCropPrice(crop_name, price, req.user.id); // req.user.id from token
    res.status(201).json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get all crop prices (public)
router.get('/', async (req, res) => {
  try {
    const prices = await getCropPrices();
    res.status(200).json(prices);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
