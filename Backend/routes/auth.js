import { Router } from 'express';
import { getUserByEmail, getUserById, createUser } from '../database.js';
import { auth } from '../middlewares/auth.js';
import bcryptjs from 'bcryptjs';
import jwt from 'jsonwebtoken';

const authRouter = Router();

authRouter.post('/api/signup', async (req, res) => {
    const password_min_length = 6;
    try {
        const {username, email, password} = req.body;
        if (!username || !email || !password) {
            return res.status(400).json({ message: 'Username, email, and password are required' });
        }
        const existingUser = await getUserByEmail(email);
        if (existingUser != null) {
            return res.status(409).json({msg: 'User with same email already exists!'});
        }
        if (password.length < password_min_length ) {
            return res.status(400).json({msg: `Password must be at least ${password_min_length} characters`})
        }
        const hashedPassword = await bcryptjs.hash(password, 10);
        const user = await createUser(username, email, hashedPassword);
        res.json(user);
    } catch (error) {
        res.status(500).json({error: error.message});
    }
});

//needs check to ensure it's a valid email
//needs validation

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

        const token = jwt.sign({id: existingUser.user_id}, "passwordKey");
        res.json({token, ...existingUser}); //see about selectively including fields later
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

        const isVerified = jwt.verify(token, "passwordKey");
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
    const user = await getUserById(req.user);
    res.json({...user, token: req.token})
});

export default authRouter;