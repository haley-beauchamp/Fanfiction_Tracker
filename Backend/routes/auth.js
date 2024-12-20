import { Router } from 'express';
import { getUserByEmail, getUserById, createUser } from '../database.js';
import { auth } from '../middlewares/auth.js';
import bcryptjs from 'bcryptjs';
import jwt from 'jsonwebtoken';

const authRouter = Router();
const secret = process.env.TOKEN_SECRET;

const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
const passRegex = /^(?=.*[0-9])(?=.*[a-zA-Z]).{8,}$/;

authRouter.post('/api/signup', async (req, res) => {
    try {
        const {username, email, password} = req.body;
        if (!username || !email || !password) {
            return res.status(400).json({ message: 'Username, email, and password are required.' });
        }
        const existingUser = await getUserByEmail(email);
        if (existingUser != null) {
            return res.status(409).json({message: 'User with same email already exists!'});
        }
        if (!emailRegex.test(email)) {
            return res.status(400).json({message: 'Invalid email.'});
        }
        if (!passRegex.test(password)) {
            return res.status(400).json({message: 'Password must contain both letters and numbers and be at least 8 characters.'});
        }
        const hashedPassword = await bcryptjs.hash(password, 10);
        const user = await createUser(username, email, hashedPassword);
        res.json(user);
    } catch (error) {
        res.status(500).json({error: error.message});
    }
});

authRouter.post('/api/signin', async (req, res) => {
    try {
        const {email, password} = req.body;
        if (!email || !password) {
            return res.status(400).json({ message: 'Email and password are required' });
        }

        const existingUser = await getUserByEmail(email);
        if (existingUser == null) {
            return res.status(400).json({ message: 'Invalid Login'});
        }

        const isMatch = await bcryptjs.compare(password, existingUser.hashed_password);
        if (!isMatch) {
            return res.status(400).json({ message: 'Invalid Login'});
        }

        const token = jwt.sign({id: existingUser.user_id}, secret);
        res.json({token, ...existingUser});
    } catch (error) {
        res.status(500).json({error: error.message});
    }
});

authRouter.post('/tokenIsValid', async (req, res) => {
    try {
        const token = req.header('x-auth-token');
        if (!token) {
            return res.json(false);
        }

        const isVerified = jwt.verify(token, secret);
        if (!isVerified) {
            return res.json(false);
        }

        const user = await getUserById(isVerified.id);
        if (!user) {
            return res.json(false);
        }

        res.json(true);
    } catch (error) {
        res.status(500).json({error: error.message});
    }
});

authRouter.get('/', auth, async (req, res) => {
    try {
        const user = await getUserById(req.user);
        res.json({...user, token: req.token});
    } catch (error) {
        res.status(500).json({error: error.message});
    }
});

export default authRouter;