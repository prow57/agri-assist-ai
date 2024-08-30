// services/weatherService.js

async function getWeatherForecast(region) {
    const staticWeatherData = {
        'North': {
            temperature: 24,
            description: 'Partly cloudy',
            humidity: 65,
        },
        'Central': {
            temperature: 28,
            description: 'Sunny',
            humidity: 55,
        },
        'South': {
            temperature: 30,
            description: 'Thunderstorms',
            humidity: 70,
        }
    };

    const weather = staticWeatherData[region];

    if (!weather) {
        return 'Weather data for the selected region is not available.';
    }

    return `Temperature: ${weather.temperature}°C, ${weather.description}, Humidity: ${weather.humidity}%`;
}

module.exports = {
    getWeatherForecast,
};
