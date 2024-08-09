const axios = require('axios');

async function getWeatherForecast(region) {
    const regionCoordinates = {
        'North': { lat: -9.22, lon: 33.93 },
        'Central': { lat: -13.96, lon: 33.79 },
        'South': { lat: -15.79, lon: 35.01 }
    };

    const { lat, lon } = regionCoordinates[region] || {};
    const apiKey = process.env.OPENWEATHERMAP_API_KEY;

    if (!lat || !lon || !apiKey) {
        return 'Unable to retrieve weather data at this time.';
    }

    try {
        const url = `https://api.openweathermap.org/data/3.0/onecall?lat=${lat}&lon=${lon}&appid=${apiKey}&units=metric`;
        const response = await axios.get(url);
        const weather = response.data;

        return `Temperature: ${weather.main.temp}°C, ${weather.weather[0].description}, Humidity: ${weather.main.humidity}%`;
    } catch (error) {
        console.error(error);
        return 'Unable to retrieve weather data at this time.';
    }
}

module.exports = {
    getWeatherForecast,
};
