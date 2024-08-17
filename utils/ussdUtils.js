
function getMainMenu() {
    return `CON Welcome to AI-Driven Agricultural Advisory System
1. Scan Leaf
2. Soil Detection
3. Weather Forecast
4. Market Prices
5. Personalized Advice
6. Community Forum`;
}

function getLeafScanInstructions() {
    return `CON To scan a leaf, send an SMS with the leaf image to 12345.`;
}

function getSoilOptions() {
    return `CON Describe your soil characteristics:
1. Sandy
2. Loamy
3. Clay
4. Peaty
5. Silty
6. Chalky`;
}

function getRegionOptions() {
    return `CON Select your region for weather forecast:
1. North
2. Central
3. South`;
}

function getCropOptions() {
    return `CON Select the crop for market prices:
1. Maize
2. Rice
3. Tobacco`;
}

function getPersonalizedAdvicePrompt() {
    return `CON Describe your agricultural issue for personalized advice:`;
}

function getCommunityForumOptions() {
    return `CON Community Forum:
1. Ask a question
2. Read recent questions`;
}

async function handleSubMenu(text, weatherService, marketService) {
    if (text.startsWith('2*')) {
        const soilType = text.split('*')[1];
        return `END Soil detection advice for ${getSoilType(soilType)}`;
    } else if (text.startsWith('3*')) {
        const region = getRegion(text.split('*')[1]);
        return `END Weather forecast for the ${region}: ${await weatherService.getWeatherForecast(region)}`;
    } else if (text.startsWith('4*')) {
        const crop = getCrop(text.split('*')[1]);
        return `END Market price for ${crop}: ${marketService.getMarketPrice(crop)}`;
    } else if (text.startsWith('5*')) {
        const issue = text.split('*').slice(1).join('*');
        return `END Personalized advice: ${getPersonalizedAdvice(issue)}`;
    } else if (text.startsWith('6*1')) {
        return `END To ask a question, send an SMS to 12345 with your question.`;
    } else if (text.startsWith('6*2')) {
        return `END Recent Questions:\n1. Question 1\n2. Question 2\n3. Question 3`;
    } else {
        return `END Invalid selection.`;
    }
}

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

function getPersonalizedAdvice(issue) {
    return `Based on your issue (${issue}), we recommend consulting a local agronomist.`;
}

module.exports = {
    getMainMenu,
    getLeafScanInstructions,
    getSoilOptions,
    getRegionOptions,
    getCropOptions,
    getPersonalizedAdvicePrompt,
    getCommunityForumOptions,
    handleSubMenu,
    getSoilType,
    getRegion,
    getCrop,
    getPersonalizedAdvice
};
