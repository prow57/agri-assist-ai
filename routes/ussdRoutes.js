const express = require('express');
const router = express.Router();
const ussdUtils = require('../utils/ussdUtils');
const weatherService = require('../services/weatherService');
const marketService = require('../services/marketService');
const aiService = require('../services/aiService');  // Import the AI service

router.post('/', async (req, res) => {
    const { sessionId, serviceCode, phoneNumber, text } = req.body;

    let response = '';

    switch (text) {
        case '':
            response = ussdUtils.getMainMenu();
            break;
        case '1':
            response = ussdUtils.getLeafScanInstructions();
            break;
        case '2':
            response = ussdUtils.getSoilOptions();
            break;
        case '3':
            response = ussdUtils.getRegionOptions();
            break;
        case '4':
            response = ussdUtils.getCropOptions();
            break;
        case '5':
            response = ussdUtils.getPersonalizedAdvicePrompt();
            break;
        case '6':
            response = ussdUtils.getCommunityForumOptions();
            break;
        default:
            response = await handleCustomMenuOptions(text, req, aiService, weatherService, marketService);
            break;
    }

    res.set('Content-Type', 'text/plain');
    res.send(response);
});

async function handleCustomMenuOptions(text, req, aiService, weatherService, marketService) {
    let response = '';

    if (text.startsWith('2*')) {
        const soilType = ussdUtils.getSoilType(text.split('*')[1]);
        response = `END Soil detection advice for ${soilType}`;
    } else if (text.startsWith('3*')) {
        const region = ussdUtils.getRegion(text.split('*')[1]);
        response = `END Weather forecast for the ${region}: ${await weatherService.getWeatherForecast(region)}`;
    } else if (text.startsWith('4*')) {
        const crop = ussdUtils.getCrop(text.split('*')[1]);
        response = `END Market price for ${crop}: ${marketService.getMarketPrice(crop)}`;
    } else if (text.startsWith('5*')) {
        const cropType = ussdUtils.getCropType(text.split('*')[1]);
        req.body.cropType = cropType;
        response = `CON Select your soil type:\n1. Sandy\n2. Loamy\n3. Clay`;
    } else if (text.startsWith('5*1*') || text.startsWith('5*2*') || text.startsWith('5*3*')) {
        const cropType = req.body.cropType;
        const soilType = ussdUtils.getSoilType(text.split('*')[2]);
        req.body.soilType = soilType;
        response = `CON Select your farming issue:\n1. General\n2. Pests\n3. Disease`;
    } else if (text.startsWith('5*1*1*') || text.startsWith('5*2*1*') || text.startsWith('5*3*1*')) {
        const cropType = req.body.cropType;
        const soilType = req.body.soilType;
        const farmingIssue = ussdUtils.getFarmingIssue(text.split('*')[3]);
        const advice = await aiService.getFarmingAdvice(soilType, cropType, farmingIssue);
        response = `END ${advice}`;
    } else if (text.startsWith('6*1')) {
        response = `END To ask a question, send an SMS to 12345 with your question.`;
    } else if (text.startsWith('6*2')) {
        response = `END Recent Questions:\n1. Question 1\n2. Question 2\n3. Question 3`;
    } else {
        response = `END Invalid selection.`;
    }

    return response;
}

module.exports = router;
