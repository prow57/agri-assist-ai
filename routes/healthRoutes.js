const express = require('express');
const router = express.Router();
const healthController = require('../controllers/healthController');

router.post('/health-assessment', healthController.healthAssessment);

module.exports = router;
