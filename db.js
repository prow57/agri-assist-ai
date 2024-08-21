import admin from 'firebase-admin';
import { readFileSync } from 'fs';
import dotenv from 'dotenv';

// Load environment variables from .env file
dotenv.config();

// Load the service account key from an environment variable
const serviceAccount = JSON.parse(readFileSync(process.env.GOOGLE_APPLICATION_CREDENTIALS, 'utf8'));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://agriassist-ai-b6fa4-default-rtdb.firebaseio.com'
});

const db = admin.firestore();

export default db;
