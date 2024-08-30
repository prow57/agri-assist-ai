function getMainMenu() {
    return `CON Welcome to Agriassist-AI
1. Scan Leaf
2. Soil Detection
3. Weather Forecast
4. Market Prices
5. Personalized Advice
6. Community Forum`;
}

function getLeafScanInstructions() {
    return `CON To scan a leaf, send an SMS with the leaf image to 12345, else use a smartphone camera.
0. Previous
#. Main Menu`;
}

function getSoilOptions() {
    return `CON Describe your soil characteristics:
1. Sandy
2. Loamy
3. Clay
4. Peaty
5. Silty
6. Chalky
0. Previous
#. Main Menu`;
}

function getRegionOptions() {
    return `CON Select your region for weather forecast:
1. North
2. Central
3. South
0. Previous
#. Main Menu`;
}

function getCropOptions() {
    return `CON Select the crop for market prices:
1. Maize
2. Rice
3. Tobacco
0. Previous
#. Main Menu`;
}

function getPersonalizedAdvicePrompt() {
    return `CON Describe your agricultural issue for personalized advice:
0. Previous
#. Main Menu`;
}

function getCommunityForumOptions() {
    return `CON Community Forum:
1. Irrigation Techniques
2. Soil Management
3. Pest Control
4. Harvesting Tips
5. Agricultural Technology
0. Previous
#. Main Menu`;
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

function getFarmingIssue(option) {
    const issues = {
        '1': 'General',
        '2': 'Pests',
        '3': 'Disease'
    };
    return issues[option] || 'Unknown issue';
}

async function handleSubMenu(text, weatherService, marketService, aiService) {
    let response = '';

    if (text.includes('*#')) {
        return getMainMenu(); // Return to the main menu when `#` is detected
    }

    if (text.includes('*0')) {
        text = getPreviousMenu(text); // Return to the previous menu when `0` is detected
    }

    if (text.startsWith('2*')) {
        const soilType = getSoilType(text.split('*')[1]);
        response = `END Soil detection advice for ${soilType}`;
    } else if (text.startsWith('3*')) {
        const region = getRegion(text.split('*')[1]);
        try {
            const weatherData = await weatherService.fetchWeather(region);
            const weatherInfo = `Temperature: ${weatherData.current.temp_c}°C, ${weatherData.current.condition.text}, Humidity: ${weatherData.current.humidity}%`;
            response = `END Weather forecast for the ${region}: ${weatherInfo}`;
        } catch (error) {
            response = `END Unable to fetch weather data at the moment. Please try again later.`;
        }
    } else if (text.startsWith('4*')) {
        const crop = getCrop(text.split('*')[1]);
        response = `END Market price for ${crop}: ${marketService.getMarketPrice(crop)}`;
    } else if (text.startsWith('5*')) {
        const [cropType, soilOption, farmingIssueOption] = text.split('*').slice(1);
        if (farmingIssueOption) {
            const soilType = getSoilType(soilOption);
            const farmingIssue = getFarmingIssue(farmingIssueOption);
            const advice = await aiService.getFarmingAdvice(soilType, cropType, farmingIssue);
            response = `END ${advice}`;
        } else if (soilOption) {
            response = `CON Select your farming issue:\n1. General\n2. Pests\n3. Disease`;
        } else {
            response = `CON Select your soil type:\n1. Sandy\n2. Loamy\n3. Clay`;
        }
    } else if (text.startsWith('6*')) {
        const communityOption = text.split('*')[1];
        response = handleCommunityForumSelection(communityOption);
    } else {
        response = `END Invalid selection.`;
    }

    return response;
}

function handleCommunityForumSelection(option) {
    let response;
    switch(option) {
        case '1':
            response = `END Irrigation Techniques:\nLearn about modern irrigation techniques to optimize water usage.\nFor more details, visit our mobile app or website.`;
            break;
        case '2':
            response = `END Soil Management:\nBest practices for maintaining soil health and fertility.\nFor more details, visit our mobile app or website.`;
            break;
        case '3':
            response = `END Pest Control:\nEffective methods for controlling pests and protecting your crops.\nFor more details, visit our mobile app or website.`;
            break;
        case '4':
            response = `END Harvesting Tips:\nGuidelines for harvesting crops efficiently and at the right time.\nFor more details, visit our mobile app or website.`;
            break;
        case '5':
            response = `END Agricultural Technology:\nExplore the latest technologies in agriculture.\nFor more details, visit our mobile app or website.`;
            break;
        case '0':
            response = `CON Returning to the previous menu...`; // This will be handled in handleSubMenu
            break;
        case '#':
            response = `CON Returning to the main menu...`; // This will be handled in handleSubMenu
            break;
        default:
            response = `END Invalid selection. Please try again.`;
    }

    return response;
}

function getPreviousMenu(text) {
    const parts = text.split('*');
    parts.pop(); // Remove the last part to go to the previous menu
    return parts.join('*') || ''; // Join the remaining parts or return an empty string for the main menu
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
    getFarmingIssue,
    handleCommunityForumSelection,
    getPreviousMenu
};
