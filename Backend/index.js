import express from 'express';

import authRouter from './routes/auth.js';

const PORT = 3000;
const app = express();

app.use(express.json());
app.use(authRouter);

app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something broke!');
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port ${PORT}`);
});