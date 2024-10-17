import { Router } from 'express';
const fanficRouter = Router();
import { getFanficByLink } from '../database.js';

fanficRouter.post('/api/findfanfic', async (req, res) => {
    try {
        const { link } = req.body;
        
        if (!link) {
            return res.status(400).json({ message: 'Link is required' });
        }

        const existingFanfic = await getFanficByLink(link);
        if (existingFanfic == null) {
            //logic to find the fanfic????
            return res.status(400).json({ message: 'That fanfic is not yet available to add.' });
        }

        res.json(existingFanfic);

    } catch (error) {
        res.status(500).json({error: error.message});
    }
});

export default fanficRouter;