const express = require('express');
const { addCropPrice, getCropPrices, updateCropPrice, deleteCropPrice } = require('../services/cropPriceService');
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

// Update a crop price by ID (authenticated)
router.put('/edit/:id', authMiddleware, async (req, res) => {
  const { id } = req.params;
  const { crop_name, price } = req.body;
  try {
    const updatedCrop = await updateCropPrice(id, crop_name, price);
    res.status(200).json(updatedCrop);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete a crop price by ID (authenticated)
router.delete('/delete/:id', authMiddleware, async (req, res) => {
  const { id } = req.params;
  try {
    const isDeleted = await deleteCropPrice(id);
    if (isDeleted) {
      res.status(204).end(); // No content
    } else {
      res.status(404).json({ error: 'Crop not found' });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
