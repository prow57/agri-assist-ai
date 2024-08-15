const marketService = require('../services/marketService');

// Add a new market
const addMarket = async (req, res) => {
    const { name, location } = req.body;

    if (!name || !location) {
        return res.status(400).json({ error: 'Name and location are required' });
    }

    try {
        await marketService.createMarket(name, location);
        res.status(201).json({ message: 'Market created successfully' });
    } catch (error) {
        res.status(500).json({ error: 'Happened in controller' + error.message });
    }
};

// Get all markets
const getMarkets = async (req, res) => {
    try {
        const markets = await marketService.getAllMarkets();
        res.status(200).json(markets);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Render the form for adding a new market (if using a template engine)
const renderCreateMarketForm = (req, res) => {
    res.render('addMarket'); // Ensure this view is properly set up in your view engine
};

module.exports = { addMarket, getMarkets, renderCreateMarketForm };
