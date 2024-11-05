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
            //summary: $('blockquote.userstuff').first().text().trim(),
            summary: (() => {
                const blockquotes = $('blockquote.userstuff');
                const firstBlockquote = blockquotes.first();    
                //check if blockquote is in announcement div
                const isInAnnouncement = firstBlockquote.closest('div.announcement.group').length > 0;
                if (isInAnnouncement) {
                    return blockquotes.eq(1).text().trim(); // If so, get the next one, which should be the summary
                }
            
                return firstBlockquote.text().trim(); // Otherwise, proceed with the first blockquote
            })(), //gets only the summary blockquote, so this exludes both "notes" sections and announcements
            tags: $('dd ul li a').map(function() {
                return $(this).text().trim();
            }).get(), //get the tag objects, add them to a list, convert them to a regular array
        };

        return fanficData;
    } catch (error) {
        console.error("Scraping error:", error.message);
        throw error;
    }
}