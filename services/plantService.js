const axios = require('axios');
require('dotenv').config();

const scanCrop = async (imageData) => {
  try {
    const response = await axios.post(
      'https://plant.id/api/v3/identify',
      {
        api_key: process.env.PLANT_ID_API_KEY,
        images: [imageData],
        modifiers: ['crops']
      }
    );
    return response.data;
  } catch (error) {
    throw new Error('Error scanning crop: ' + error.message);
  }
};

module.exports = { scanCrop };
