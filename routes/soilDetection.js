const express = require('express');
const multer = require('multer');
const { analyzeSoil } = require('../services/soilDetectionService');
const router = express.Router();

const upload = multer({ dest: 'uploads/' });

router.post('/', upload.single('file'), async (req, res) => {
    try {
        const result = await analyzeSoil(req.file.path);
        res.json(result);
    } catch (error) {
        res.status(500).send(error.message);
    }
});

module.exports = router;
