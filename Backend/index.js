import express from 'express';
import { getUsers, getUser, createUser } from './database.js';

import authRouter from './routes/auth.js';

const PORT = 3000;
const app = express();

app.use(authRouter);

app.get("/users", async (req, res, next) => {
    try {
        const users = await getUsers();
        res.send(users);
    } catch (err) {
        next(err);
    }
});

app.get("/users/:id", async (req, res, next) => {
    try {
        const id = req.params.id;
        const user = await getUser(id);
        res.send(user);
    } catch (err) {
        next(err);
    }
});

app.post("/users", async (req, res, next) => {
    try {
        const {name, email, password} = req.body;
        const user = await createUser(name, email, password);
        res.status(201).send(user);
    } catch (err) {
        next(err);
    }
});

app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something broke!');
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port ${PORT}`);
});