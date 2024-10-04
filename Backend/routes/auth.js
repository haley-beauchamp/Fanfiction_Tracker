import { Router } from 'express';
import { getUsers, getUser, createUser } from '../database.js';

const authRouter = Router();

authRouter.post('/api/signup', async (req, res) => {
    const {name, email, password} = req.body;
    const user = await createUser(name, email, password);
    res.status(201).send(user);
});

//add check to see if email is already in the database
//needs validation

export default authRouter;