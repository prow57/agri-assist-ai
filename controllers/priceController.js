const priceService = require('../services/priceService');

const addPrice = async (req, res) => {
  const { product_id, market_id, price } = req.body;
  const userId = req.user.id; // assuming userId is added to req.user in authentication middleware

  try {
    const result = await priceService.addPrice(product_id, market_id, price, userId);
    res.status(201).json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getPrices = async (req, res) => {
  try {
    const prices = await priceService.getPrices();
    res.status(200).json(prices);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updatePrice = async (req, res) => {
  const { id } = req.params;
  const { product_id, market_id, price } = req.body;
  
  try {
    const updatedPrice = await priceService.updatePrice(id, product_id, market_id, price);
    res.status(200).json(updatedPrice);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const deletePrice = async (req, res) => {
  const { id } = req.params;

  try {
    const isDeleted = await priceService.deletePrice(id);
    if (isDeleted) {
      res.status(204).end(); // No content
    } else {
      res.status(404).json({ error: 'Price not found' });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = { addPrice, getPrices, updatePrice, deletePrice };
