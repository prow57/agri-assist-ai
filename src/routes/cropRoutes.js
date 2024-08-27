const express = require('express');
const { addCrop, getCrops, updateCrop, deleteCrop } = require('../services/cropService');
const authMiddleware = require('../middlewares/authMiddleware');

const router = express.Router();

// Add a crop price (authenticated)
router.post('/add', authMiddleware, async (req, res) => {
  const { name, description } = req.body;
  try {
    const result = await addCrop(name, description, req.user.id); // req.user.id from token
    res.status(201).json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get all crops (public)
router.get('/', async (req, res) => {
  try {
    const crops = await getCrops();
    res.status(200).json(crops);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update a crop price by ID (authenticated)
router.put('/edit/:id', authMiddleware, async (req, res) => {
  const { id } = req.params;
  const { name, description } = req.body;
  try {
    const updatedCrop = await updateCrop(id, name, description);
    res.status(200).json(updatedCrop);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete a crop price by ID (authenticated)
router.delete('/delete/:id', authMiddleware, async (req, res) => {
  const { id } = req.params;
  try {
    const isDeleted = await deleteCrop(id);
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
