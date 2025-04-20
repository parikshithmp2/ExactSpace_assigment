const fs = require('fs');
const puppeteer = require('puppeteer');

const url = process.env.SCRAPE_URL;

if (!url) {
  console.error("No URL provided. Set SCRAPE_URL env variable.");
  process.exit(1);
}

(async () => {
  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
    executablePath: '/usr/bin/chromium-browser',
  });

  const page = await browser.newPage();
  await page.goto(url);

  const data = await page.evaluate(() => ({
    title: document.title,
    heading: document.querySelector('h1')?.innerText || "No <h1> found",
  }));

  fs.writeFileSync('/app/scraped_data.json', JSON.stringify(data, null, 2));

  await browser.close();
})();
