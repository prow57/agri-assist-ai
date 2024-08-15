const db = require('../db'); // Make sure this points to your database connection

// Add a new crop price
const addCrop = async (name, description, added_by) => {
  try {
    const result = await db.one(
      'INSERT INTO crops(name, description, added_by) VALUES($1, $2, $3) RETURNING id, name, description, added_by',
      [name, description, added_by]
    );
    return result;
  } catch (error) {
    throw new Error(`Error adding crop: ${error.message}`);
  }
};

// Get all crop prices
const getCrops = async () => {
  try {
    const crops = await db.any('SELECT * FROM crops');
    return crops;
  } catch (error) {
    throw new Error(`Error retrieving crop: ${error.message}`);
  }
};

// Update a crop price by ID
const updateCrop = async (id, name, description) => {
  try {
    const result = await db.one(
      'UPDATE crops SET name = $1, description = $2 WHERE id = $3 RETURNING id, name, description',
      [name, description, id]
    );
    return result;
  } catch (error) {
    throw new Error(`Error updating crop: ${error.message}`);
  }
};

// Delete a crop price by ID
const deleteCrop = async (id) => {
  try {
    const result = await db.result(
      'DELETE FROM crops WHERE id = $1',
      [id]
    );
    return result.rowCount > 0; // Return true if a row was deleted
  } catch (error) {
    throw new Error(`Error deleting crop: ${error.message}`);
  }
};

module.exports = { addCrop, getCrops, updateCrop, deleteCrop };
