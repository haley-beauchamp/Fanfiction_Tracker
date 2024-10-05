import { Router } from 'express';
import { getUsers, getUser, createUser } from '../database.js';
import bcryptjs from 'bcryptjs';
import jwt from 'jsonwebtoken';

const authRouter = Router();

authRouter.post('/api/signup', async (req, res) => {
    try {
        const {username, email, password} = req.body;
        if (!username || !email || !password) {
            return res.status(400).json({ message: 'Username, email, and password are required' });
        }
        const existingUser = await getUser(email);
        if (existingUser != null) {
            return res.status(409).json({msg: 'User with same email already exists!'});
        }
        const hashedPassword = await bcryptjs.hash(password, 10);
        const user = await createUser(username, email, hashedPassword);
        res.json(user);
    } catch (error) {
        res.status(500).json({error: error.message});
    }
});

//needs validation
//needs password length requirements

authRouter.post('/api/signin', async (req, res) => {
    try {
        const {email, password} = req.body;
        if (!email || !password) {
            return res.status(400).json({ message: 'Email and password are required' });
        }

        const existingUser = await getUser(email);
        if (existingUser == null) {
            return res.status(400).json({ message: 'Invalid Login (email)'});
        }

        const isMatch = await bcryptjs.compare(password, existingUser.hashed_password);
        if (!isMatch) {
            return res.status(400).json({ message: 'Invalid Login (pwd)'});
        }

        const token = jwt.sign({id: existingUser._id}, "passwordKey");
        res.json({token, ...existingUser._doc});
    } catch (error) {
        res.status(500).json({error: error.message});
    }
});

export default authRouter;