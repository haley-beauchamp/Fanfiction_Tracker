import { Router } from 'express';
const fanficRouter = Router();
import { getFanficByLink, addFanfic, getFanficReviewByIds, getFanficsByList } from '../database.js';

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

fanficRouter.post('/api/addfanfic', async (req, res) => {
    try {
        const {userId, fanficId, rating, review, favoriteMoments, assignedList} = req.body;

        const fanficReview = await getFanficReviewByIds(userId, fanficId);
        if (fanficReview != null) {
            return res.status(400).json({ message: 'You already reviewed that one, you goof!'});
        }
        await addFanfic(userId, fanficId, rating, review, favoriteMoments, assignedList);
    } catch(error) {
        res.status(500).json({error: error.message});
    }
});

fanficRouter.post('/api/fanficsbylist', async (req, res) => {
    try {
        const {userId, assignedList} = req.body;

        const fanfics = await getFanficsByList(userId, assignedList);
        res.json(fanfics);
    } catch(error) {
        res.status(500).json({error: error.message});
    }
});

export default fanficRouter;