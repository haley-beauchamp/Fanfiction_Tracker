import axios from 'axios';
import * as cheerio from 'cheerio';

export async function scrapeData(link) {
    try {
        const { data } = await axios.get(link);

        const $ = cheerio.load(data);

        const fanficData = {
            fandom: $('dd.fandom.tags ul.commas li a.tag').first().text().trim(), //gets the first fandom only
            title: $('h2.title.heading').text().trim(),
            author: $('h3.byline.heading a[rel="author"]').text().trim(),
            summary: $('blockquote.userstuff').text().trim(),
        };

        return fanficData;
    } catch (error) {
        console.error("Scraping error:", error.message);
        throw error;
    }
}