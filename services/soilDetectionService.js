const { spawn } = require('child_process');
const fs = require('fs');
const db = require('../firebase');
const admin = require('firebase-admin');

const analyzeSoil = async (filePath) => {
    return new Promise((resolve, reject) => {
        const pythonProcess = spawn('python', ['python-scripts/inference.py', filePath]);

        pythonProcess.stdout.on('data', (data) => {
            const result = JSON.parse(data.toString());

            // Store result in Firestore
            const firestoreResult = {
                timestamp: admin.firestore.FieldValue.serverTimestamp(),
                prediction: result
            };
            db.collection('soilDetections').add(firestoreResult);

            resolve(result);
        });

        pythonProcess.stderr.on('data', (data) => {
            reject(data.toString());
        });
    });
};

module.exports = { analyzeSoil };
