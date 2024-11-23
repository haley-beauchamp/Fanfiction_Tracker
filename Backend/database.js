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
        const fanfic = tuples[0];

        if (fanfic != null) {
            const fanficTags = await getFanficTags(fanfic.fanfic_id);
            fanfic.tags = fanficTags;
        }

        return fanfic;
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    } 
}

export async function addFanfic(userId, fanficId, rating, review, favoriteMoments, assignedList, favoriteFanficTags) {
    try {
        await pool.query(
            `INSERT INTO fanfic_subjective (user_id, fanfic_id, rating, review, favorite_moments, assigned_list) values (?,?,?,?,?,?)`, 
            [userId, fanficId, rating, review, favoriteMoments, assignedList]);
        for (const tag of favoriteFanficTags) {
            const tagId = await getTagId(tag);
            await pool.query(
                `INSERT INTO user_favorite_tags (user_id, fanfic_id, tag_id) values (?,?,?)`,
                [userId, fanficId, tagId]
            );
        }
        return getFanficReviewByIds(userId, fanficId);
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}

export async function getFanficReviewByIds(userId, fanficId) {
    try {
        const [tuples] = await pool.query(`SELECT * FROM fanfic_subjective JOIN fanfic_objective ON fanfic_subjective.fanfic_id = fanfic_objective.fanfic_id WHERE user_id = ? AND fanfic_subjective.fanfic_id = ?`, [userId, fanficId]);
        return tuples[0];
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}

export async function getFanficsByList(userId, assignedList) {
    try {
        const [fanfics] = await pool.query(`SELECT * FROM fanfic_objective JOIN fanfic_subjective ON fanfic_subjective.fanfic_id = fanfic_objective.fanfic_id WHERE user_id = ? AND assigned_list = ?`, [userId, assignedList]);

        for (var fanfic of fanfics) {
            const fanficTags = await getFanficTags(fanfic.fanfic_id);
            fanfic.tags = fanficTags;

            const favoriteFanficTags = await getFavoriteFanficTags(userId, fanfic.fanfic_id);
            fanfic.favorite_tags = favoriteFanficTags;
        }

        return fanfics;
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}

export async function addFanficFromScraper(link, fandom, title, author, summary, tags) {
    try {
        await pool.query(`INSERT INTO fanfic_objective (link, fandom, title, author, summary) VALUES (?,?,?,?,?)`, [link, fandom, title, author, summary]);
        const baseFanfic = await getFanficByLink(link);
        const fanficId = baseFanfic.fanfic_id;

        for (var tagName of tags) {
            let tagId = await getTagId(tagName);
            if (tagId == null) {
                await pool.query(`INSERT INTO tags (tag_name) VALUES (?)`, [tagName]);
                tagId = await getTagId(tagName);
            }
            await pool.query(`INSERT INTO fanfic_tags VALUES (?, ?)`, [fanficId, tagId]);
        }

        const fanficTags = await getFanficTags(baseFanfic.fanfic_id);
        baseFanfic.tags = fanficTags;
        return baseFanfic;
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}

export async function getTagId(tagName) {
    try {
        const [result] = await pool.query(`SELECT * FROM tags WHERE tag_name = ?`, [tagName]);
        //return result[0].tag_id;
        return result.length > 0 ? result[0].tag_id : null;
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}

export async function getFanficTags(fanficId) {
    try {
        const [tags] = await pool.query(`SELECT tag_name FROM fanfic_tags JOIN tags ON fanfic_tags.tag_id = tags.tag_id WHERE fanfic_id = ?`, [fanficId]);
        const tagNames = tags.map(tag => tag.tag_name);;
        return tagNames;
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}

export async function getFavoriteFanficTags(userId, fanficId) {
    try {
        const [tags] = await pool.query(`SELECT tag_name FROM fanfic_tags AS ft JOIN tags ON ft.tag_id = tags.tag_id JOIN user_favorite_tags AS ut ON ft.tag_id = ut.tag_id WHERE user_id = ? AND ft.fanfic_id = ?`, [userId, fanficId]);
        const tagNames = tags.map(tag => tag.tag_name);;
        return tagNames;
    } catch (err) {
        console.error('Error executing query:', err);
        throw err;
    }
}