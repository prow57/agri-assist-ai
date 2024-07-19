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

// test request handler 

app.get('/', function(req, res) {
    res.send('test request is working')
})

app.post('/ussd', (req, res) => {
    const { sessionId, serviceCode, phoneNumber, text } = req.body;

    let response = '';

    if (text === '') {
        response = `CON Welcome to AI-Driven Agricultural Advisory System\n1. Get Farming Advice\n2. Get Weather Forecast\n3. Market Prices`;
    } else if (text === '1') {
        response = `CON Select the type of advice you need\n1. Planting\n2. Irrigation\n3. Fertilization`;
    } else if (text === '2') {
        response = `CON Select your region\n1. North\n2. Central\n3. South`;
    } else if (text === '3') {
        response = `CON Select the crop\n1. Maize\n2. Rice\n3. Tobacco`;
    } else if (text === '1*1') {
        response = `END Planting advice: ${getPlantingAdvice()}`;
    } else if (text === '1*2') {
        response = `END Irrigation advice: ${getIrrigationAdvice()}`;
    } else if (text === '1*3') {
        response = `END Fertilization advice: ${getFertilizationAdvice()}`;
    } else if (text === '2*1') {
        response = `END Weather forecast for the North: ${getWeatherForecast('North')}`;
    } else if (text === '2*2') {
        response = `END Weather forecast for the Central region: ${getWeatherForecast('Central')}`;
    } else if (text === '2*3') {
        response = `END Weather forecast for the South: ${getWeatherForecast('South')}`;
    } else if (text === '3*1') {
        response = `END Market price for Maize: ${getMarketPrice('Maize')}`;
    } else if (text === '3*2') {
        response = `END Market price for Rice: ${getMarketPrice('Rice')}`;
    } else if (text === '3*3') {
        response = `END Market price for Tobacco: ${getMarketPrice('Tobacco')}`;
    } else {
        response = `END Invalid selection.`;
    }

    res.set('Content-Type', 'text/plain');
    res.send(response);
});

function getPlantingAdvice() {
    return "Use improved seed varieties and practice crop rotation.";
}

function getIrrigationAdvice() {
    return "Irrigate your crops early in the morning or late in the evening.";
}

function getFertilizationAdvice() {
    return "Apply organic fertilizers and avoid over-fertilization.";
}

function getWeatherForecast(region) {
    return "Sunny with a chance of rain in the afternoon.";
}

function getMarketPrice(crop) {
    return `The current price for ${crop} is MWK 200 per kg.`;
}

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});
