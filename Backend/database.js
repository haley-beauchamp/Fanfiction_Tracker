import { createPool } from 'mysql2';
import { config } from 'dotenv';

config();

const pool = createPool({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASSWORD,
    database: process.env.MYSQL_DATABASE
}).promise();

export async function getUsers() {
    try {
        const [tuples] = await pool.query("SELECT * FROM users");
        return tuples;
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}

export async function getUser(user_id) {
    try {
        const [tuples] = await pool.query(`SELECT * FROM users WHERE user_id = ?`, [user_id]);
        return tuples[0];
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}

export async function createUser(username, email, hashed_password) {
    try {
        const [result] = await pool.query(`INSERT INTO users (username, email, hashed_password) VALUES (?,?,?)`, [username, email, hashed_password]);
        const id = result.id;
        return(getUsers(id));
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}

// getUsers().then((users) => {
//     console.log(users);
// });

// getUser(1).then((user) => {
//     console.log(user);
// });

// createUser('us', 'us@gmail.com', 'ourpassword').then((user) => {
//     console.log(user);
// });