// firebase.js
const admin = require('firebase-admin');
const serviceAccount = require('./agriassist.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://agriassist-ai-b6fa4-default-rtdb.firebaseio.com'
});

const db = admin.firestore();

module.exports = db;