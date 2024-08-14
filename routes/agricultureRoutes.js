const express = require('express');
const router = express.Router();
const agricultureController = require('../controllers/agricultureController');

// Route for generating courses or lessons
router.post('/generate-course', agricultureController.generateCourse);

// Route for AI advice
router.post('/get-ai-advice', agricultureController.getAiAdvice);

// Route for AI chat conversation
router.post('/chat', agricultureController.chatWithAi);

module.exports = router;
