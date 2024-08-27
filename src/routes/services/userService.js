const bcrypt = require('bcrypt');
const db = require('../db');

const SALT_ROUNDS = 10; // Define the number of salt rounds

async function createUser(username, email, password) {
  try {
    // Generate salt and hash the password
    const salt = await bcrypt.genSalt(SALT_ROUNDS);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Insert user into the database
    const result = await db.one(
      'INSERT INTO users(username, email, password) VALUES($1, $2, $3) RETURNING id, username, email',
      [username, email, hashedPassword]
    );
    return result;
  } catch (error) {
    throw new Error(`Error creating user: ${error.message}`);
  }
}

async function findUserByUsername(username) {
  try {
    // Find user by username
    const user = await db.oneOrNone('SELECT * FROM users WHERE username = $1', [username]);
    return user;
  } catch (error) {
    throw new Error(`Error finding user: ${error.message}`);
  }
}

module.exports = { createUser, findUserByUsername };
