const db = require('../db');

// Add a new market
const createMarket = async (name, location) => {
    try {
        const result = await db.one(
            'INSERT INTO markets (name, location) VALUES ($1, $2) RETURNING id, name, location',
            [name, location]
        );
        return result; // Return the inserted market
    } catch (error) {
        throw new Error(`Error adding market: ${error.message}`);
    }
};

// Get all markets
const getAllMarkets = async () => {
    try {
        const result = await db.any('SELECT * FROM markets');
        return result;
    } catch (error) {
        throw new Error(`Error retrieving markets: ${error.message}`);
    }
};

// Update a market by ID
const updateMarket = async (id, name, location) => {
    try {
        const result = await pool.query(
            'UPDATE markets SET name = $1, location = $2 WHERE id = $3 RETURNING id, name, location',
            [name, location, id]
        );
        if (result.rowCount === 0) {
            throw new Error('Market not found');
        }
        return result.rows[0];
    } catch (error) {
        throw new Error(`Error updating market: ${error.message}`);
    }
};

// Delete a market by ID
const deleteMarket = async (id) => {
    try {
        const result = await pool.query(
            'DELETE FROM markets WHERE id = $1',
            [id]
        );
        return result.rowCount > 0; // Return true if a row was deleted
    } catch (error) {
        throw new Error(`Error deleting market: ${error.message}`);
    }
};

module.exports = { createMarket, getAllMarkets, updateMarket, deleteMarket };
