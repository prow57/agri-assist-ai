require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
// const africastalking = require('africastalking');

const app = express();
const port = 3000;

app.use(bodyParser.urlencoded({ extended: true }));

// Initialize Africa's Talking
// const africasTalking = africastalking({
//     username: process.env.AT_USERNAME,
//     apiKey: process.env.AT_API_KEY
// });

// const ussd = africasTalking.USSD;

app.get('/', function(req, res) {
    res.send('test request is working');
});

app.post('/ussd', (req, res) => {
    const { sessionId, serviceCode, phoneNumber, text } = req.body;

    let response = '';

    if (text === '') {
        response = `CON Welcome to AI-Driven Agricultural Advisory System\n1. Scan Leaf\n2. Soil Detection\n3. Weather Forecast\n4. Market Prices\n5. Personalized Advice`;
    } else if (text === '1') {
        response = `CON To scan a leaf, send an SMS with the leaf image to 12345.`;
    } else if (text === '2') {
        response = `CON Describe your soil characteristics:\n1. Sandy\n2. Loamy\n3. Clay\n4. Peaty\n5. Silty\n6. Chalky`;
    } else if (text === '3') {
        response = `CON Select your region for weather forecast:\n1. North\n2. Central\n3. South`;
    } else if (text === '4') {
        response = `CON Select the crop for market prices:\n1. Maize\n2. Rice\n3. Tobacco`;
    } else if (text === '5') {
        response = `CON Describe your agricultural issue for personalized advice:`;
    } else if (text.startsWith('2*')) {
        const soilType = text.split('*')[1];
        response = `END Soil detection advice for ${getSoilType(soilType)}`;
    } else if (text.startsWith('3*')) {
        const region = getRegion(text.split('*')[1]);
        response = `END Weather forecast for the ${region}: ${getWeatherForecast(region)}`;
    } else if (text.startsWith('4*')) {
        const crop = getCrop(text.split('*')[1]);
        response = `END Market price for ${crop}: ${getMarketPrice(crop)}`;
    } else if (text.startsWith('5*')) {
        const issue = text.split('*').slice(1).join('*');
        response = `END Personalized advice: ${getPersonalizedAdvice(issue)}`;
    } else {
        response = `END Invalid selection.`;
    }

    res.set('Content-Type', 'text/plain');
    res.send(response);
});

function getSoilType(option) {
    const types = {
        '1': 'Sandy',
        '2': 'Loamy',
        '3': 'Clay',
        '4': 'Peaty',
        '5': 'Silty',
        '6': 'Chalky'
    };
    return types[option] || 'Unknown soil type';
}

function getRegion(option) {
    const regions = {
        '1': 'North',
        '2': 'Central',
        '3': 'South'
    };
    return regions[option] || 'Unknown region';
}

function getCrop(option) {
    const crops = {
        '1': 'Maize',
        '2': 'Rice',
        '3': 'Tobacco'
    };
    return crops[option] || 'Unknown crop';
}

function getWeatherForecast(region) {
    return `Sunny with a chance of rain in the ${region} in the afternoon.`;
}

function getMarketPrice(crop) {
    return `The current price for ${crop} is MWK 200 per kg.`;
}

function getPersonalizedAdvice(issue) {
    return `Based on your issue (${issue}), we recommend consulting a local agronomist.`;
}

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});
