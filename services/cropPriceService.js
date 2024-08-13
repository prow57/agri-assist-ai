const db = require('../db'); // Make sure this points to your database connection

// Add a new crop price
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

// Get all crop prices
const getCropPrices = async () => {
  try {
    const prices = await db.any('SELECT * FROM crop_prices ORDER BY created_at DESC');
    return prices;
  } catch (error) {
    throw new Error(`Error retrieving crop prices: ${error.message}`);
  }
};

// Update a crop price by ID
const updateCropPrice = async (id, crop_name, price) => {
  try {
    const result = await db.one(
      'UPDATE crop_prices SET crop_name = $1, price = $2 WHERE id = $3 RETURNING id, crop_name, price',
      [crop_name, price, id]
    );
    return result;
  } catch (error) {
    throw new Error(`Error updating crop price: ${error.message}`);
  }
};

// Delete a crop price by ID
const deleteCropPrice = async (id) => {
  try {
    const result = await db.result(
      'DELETE FROM crop_prices WHERE id = $1',
      [id]
    );
    return result.rowCount > 0; // Return true if a row was deleted
  } catch (error) {
    throw new Error(`Error deleting crop price: ${error.message}`);
  }
};

module.exports = { addCropPrice, getCropPrices, updateCropPrice, deleteCropPrice };
