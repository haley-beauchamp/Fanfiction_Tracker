import { Router } from 'express';
const fanficRouter = Router();
import { getFanficByLink, addFanfic, getFanficReviewByIds, getFanficsByList, addFanficFromScraper, deleteReview, updateFanficReview } from '../database.js';
import { scrapeData } from '../scrapers/scraper.js';

fanficRouter.post('/api/findfanfic', async (req, res) => {
    const baseURL = 'https://archiveofourown.org/works/';
    try {
        const { link } = req.body;
        
        if (!link) {
            return res.status(400).json({ message: 'Link is required' });
        }

        const existingFanfic = await getFanficByLink(link);
        if (existingFanfic == null) {
            if (!link.startsWith(baseURL)) {
                return res.status(400).json({ message: 'Invalid Link' });
            }

            const {fandom, title, author, summary, tags} = await scrapeData(link);
            const newFanfic = await addFanficFromScraper(link, fandom, title, author, summary, tags);
            res.json(newFanfic);
        }

        res.json(existingFanfic);

    } catch (error) {
        res.status(500).json({error: error.message});
    }
});

fanficRouter.post('/api/addfanfic', async (req, res) => {
    try {
        const {userId, fanficId, rating, review, favoriteMoments, assignedList, favoriteTags} = req.body;

        const fanficReview = await getFanficReviewByIds(userId, fanficId);
        if (fanficReview != null) {
            return res.status(400).json({ message: 'You already reviewed that one, you goof!'});
        }
        const fanfic = await addFanfic(userId, fanficId, rating, review, favoriteMoments, assignedList, favoriteTags);
        res.json(fanfic);
    } catch(error) {
        res.status(500).json({error: error.message});
    }
});

fanficRouter.post('/api/fanficsbylist', async (req, res) => {
    try {
        const {userId, assignedList, assignedSort} = req.body;

        const fanfics = await getFanficsByList(userId, assignedList, assignedSort);
        res.json(fanfics);
    } catch(error) {
        res.status(500).json({error: error.message});
    }
});

fanficRouter.delete('/api/deletereview', async (req, res) => {
    try {
        const {userId, fanficId} = req.body;
        await deleteReview(userId, fanficId);
        res.status(200).json({ message: 'Review successfully deleted.'});
    } catch {
        res.status(500).json({error: error.message});
    }
});

fanficRouter.post('/api/updatefanficreview', async (req, res) => {
    try {
        const {userId, fanficId, rating, review, favoriteMoments, assignedList, favoriteTags} = req.body;
        const fanfic = await updateFanficReview(userId, fanficId, rating, review, favoriteMoments, assignedList, favoriteTags);
        res.json(fanfic);
    } catch {
        res.status(500).json({error: error.message});
    }
});

export default fanficRouter;