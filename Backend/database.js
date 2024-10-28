import { createPool } from 'mysql2';
import { config } from 'dotenv';

config();

const pool = createPool({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASSWORD,
    database: process.env.MYSQL_DATABASE
}).promise();

export async function getUserByEmail(email) {
    try {
        const [tuples] = await pool.query(`SELECT * FROM users WHERE email = ?`, [email]);
        return tuples[0];
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}

export async function getUserById(id) {
    try {
        const [tuples] = await pool.query(`SELECT * FROM users WHERE user_id = ?`, [id]);
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
        return(getUserById(id));
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}

export async function getFanficByLink(link) {
    try {
        const [tuples] = await pool.query(`SELECT * FROM fanfic_objective WHERE link = ?`, [link]);
        return tuples[0];
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    } 
}

export async function addFanfic(userId, fanficId, rating, review, favorite_moments, assigned_list) {
    try {
        await pool.query(
            `INSERT INTO fanfic_subjective (user_id, fanfic_id, rating, review, favorite_moments, assigned_list) values (?,?,?,?,?,?)`, 
            [userId, fanficId, rating, review, favorite_moments, assigned_list]);
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}

export async function getFanficReviewByIds(userId, fanficId) {
    try {
        const [tuples] = await pool.query(`SELECT * FROM fanfic_subjective WHERE user_id = ? AND fanfic_id = ?`, [userId, fanficId]);
        return tuples[0];
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}

export async function getFanficsByList(userId, assignedList) {
    try {
        const [tuples] = await pool.query(`SELECT * FROM fanfic_objective JOIN fanfic_subjective ON fanfic_subjective.fanfic_id = fanfic_objective.fanfic_id WHERE user_id = ? AND assigned_list = ?`, [userId, assignedList]);
        return tuples;
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}

export async function addFanficFromScraper(link, fandom, title, author, summary) {
    try {
        await pool.query(`INSERT INTO fanfic_objective (link, fandom, title, author, summary) VALUES (?,?,?,?,?)`, [link, fandom, title, author, summary]);
        return getFanficByLink(link);
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}