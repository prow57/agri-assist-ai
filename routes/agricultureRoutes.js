// routes/agricultureRoutes.js
const express = require('express');
const {
  generateCourseController,
  getAiAdviceController,
  chatWithAiController,
} = require('../controllers/agricultureController');

const router = express.Router();

router.post('/generate-course', generateCourseController);
router.post('/get-ai-advice', getAiAdviceController);
router.post('/chat', chatWithAiController);

module.exports = router;
