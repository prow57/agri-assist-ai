const db = require('../db'); // Make sure this points to your database connection

// Add a new price
const addPrice = async (product_id, market_id, price, added_by) => {
  try {
    const result = await db.one(
      'INSERT INTO prices (product_id, market_id, price, added_by) VALUES ($1, $2, $3, $4) RETURNING id, product_id, market_id, price, added_by',
      [product_id, market_id, price, added_by]
    );
    return result;
  } catch (error) {
    throw new Error(`Error adding price: ${error.message}`);
  }
};

// Get all prices
const getPrices = async () => {
  try {
    const prices = await db.any('SELECT * FROM prices ORDER BY created_at DESC');
    return prices;
  } catch (error) {
    throw new Error(`Error retrieving prices: ${error.message}`);
  }
};

// Update a price by ID
const updatePrice = async (id, product_id, market_id, price) => {
  try {
    const result = await db.one(
      'UPDATE prices SET product_id = $1, market_id = $2, price = $3 WHERE id = $4 RETURNING id, product_id, market_id, price',
      [product_id, market_id, price, id]
    );
    return result;
  } catch (error) {
    throw new Error(`Error updating price: ${error.message}`);
  }
};

// Delete a price by ID
const deletePrice = async (id) => {
  try {
    const result = await db.result(
      'DELETE FROM prices WHERE id = $1',
      [id]
    );
    return result.rowCount > 0; // Return true if a row was deleted
  } catch (error) {
    throw new Error(`Error deleting price: ${error.message}`);
  }
};

module.exports = { addPrice, getPrices, updatePrice, deletePrice };
