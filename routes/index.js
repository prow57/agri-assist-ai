const express = require('express');
const { analyzeCrop } = require('../controllers/plantController');

const router = express.Router();

router.post('/analyze-crop', analyzeCrop);

module.exports = router;
