// controllers/cropPriceController.js
const cropPriceService = require('../services/cropPriceService');

const addCropPrice = async (req, res) => {
  const { crop_name, price } = req.body;
  const userId = req.user.id; // assuming userId is added to req.user in authentication middleware

  try {
    const result = await cropPriceService.addCropPrice(crop_name, price, userId);
    res.status(201).json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getCropPrices = async (req, res) => {
  try {
    const prices = await cropPriceService.getCropPrices();
    res.status(200).json(prices);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = { addCropPrice, getCropPrices };
