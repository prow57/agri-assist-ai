// services/cropPriceService.js
const db = require('../db'); // Make sure this points to your database connection

const addCropPrice = async (crop_name, price, added_by) => {
  try {
    const result = await db.one(
      'INSERT INTO crop_prices(crop_name, price, added_by) VALUES($1, $2, $3) RETURNING id, crop_name, price, added_by',
      [crop_name, price, added_by]
    );
    return result;
  } catch (error) {
    throw new Error(`Error adding crop price: ${error.message}`);
  }
};

const getCropPrices = async () => {
  try {
    const prices = await db.any('SELECT * FROM crop_prices ORDER BY created_at DESC');
    return prices;
  } catch (error) {
    throw new Error(`Error retrieving crop prices: ${error.message}`);
  }
};

module.exports = { addCropPrice, getCropPrices };
