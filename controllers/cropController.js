// controllers/cropPriceController.js
const cropService = require('../services/cropService');

const addCrop = async (req, res) => {
  const { name, description } = req.body;
  const userId = req.user.id; // assuming userId is added to req.user in authentication middleware

  try {
    const result = await cropService.addCrop(name, description, userId);
    res.status(201).json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getCrops = async (req, res) => {
  try {
    const crops = await cropService.getCrops();
    res.status(200).json(crops);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = { addCrop, getCrops };
