import { Router } from 'express';
import { getUsers, getUser, createUser } from '../database.js';
import bcrypt from 'bcryptjs';

const authRouter = Router();

authRouter.post('/api/signup', async (req, res) => {
    const {username, email, password} = req.body;
    if (!username || !email || !password) {
        return res.status(400).json({ message: 'Username, email, and password are required' });
    }
    const existingUser = await getUser(email);
    if (existingUser != null) {
        return res.status(409).json({msg: 'User with same email already exists!'});
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    const user = await createUser(username, email, hashedPassword);
    res.json(user);
});

//needs validation
//needs password length requirements

export default authRouter;