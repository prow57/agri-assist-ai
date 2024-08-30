const express = require('express');
const router = express.Router();
const ussdUtils = require('../utils/ussdUtils');
const weatherService = require('../services/weatherService');
const marketService = require('../services/marketService');
const aiService = require('../services/aiService');

router.post('/', async (req, res) => {
    const { sessionId, serviceCode, phoneNumber, text } = req.body;

    let response = '';

    if (text === '') {
        response = ussdUtils.getMainMenu();
    } else if (text === '1') {
        response = ussdUtils.getLeafScanInstructions();
    } else if (text === '2') {
        response = ussdUtils.getSoilOptions();
    } else if (text === '3') {
        response = ussdUtils.getRegionOptions();
    } else if (text === '4') {
        response = ussdUtils.getCropOptions();
    } else if (text === '5') {
        response = ussdUtils.getPersonalizedAdvicePrompt();
    } else if (text === '6') {
        response = ussdUtils.getCommunityForumOptions();
    } else {
        response = await ussdUtils.handleSubMenu(text, weatherService, marketService, aiService);
    }

    res.set('Content-Type', 'text/plain');
    res.send(response);
});

module.exports = router;
