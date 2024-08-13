// routes/cropPriceRoutes.js
const express = require('express');
const { addCropPrice, getCropPrices } = require('../controllers/cropPriceController');
const authMiddleware = require('../middlewares/authMiddleware'); // Authentication middleware

const router = express.Router();

// Public route to get crop prices
router.get('/', getCropPrices);

// Protected route to add crop price
router.post('/', authMiddleware, addCropPrice);

module.exports = router;
