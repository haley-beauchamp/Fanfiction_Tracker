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

export async function getUser(email) {
    try {
        const [tuples] = await pool.query(`SELECT * FROM users WHERE email = ?`, [email]);
        return tuples[0];
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}

export async function createUser(username, email, hashedPassword) {
    try {
        const [result] = await pool.query(`INSERT INTO users (username, email, hashed_password) VALUES (?,?,?)`, [username, email, hashedPassword]);
        const id = result.id;
        return(getUser(id));
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