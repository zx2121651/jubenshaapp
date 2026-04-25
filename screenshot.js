const puppeteer = require('puppeteer');
const path = require('path');
const express = require('express');
const app = express();

app.use(express.static(path.join(__dirname, 'build/web')));
// Catch-all route to serve index.html for client-side routing
app.use((req, res) => {
    res.sendFile(path.join(__dirname, 'build/web', 'index.html'));
});

const server = app.listen(8080, async () => {
    console.log('Server running on port 8080');

    try {
        const browser = await puppeteer.launch({
            args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-web-security'],
            headless: 'new'
        });
        const page = await browser.newPage();

        // Emulate a mobile device
        await page.setViewport({ width: 375, height: 812, isMobile: true, hasTouch: true });

        console.log('Navigating to http://localhost:8080');
        await page.goto('http://localhost:8080', { waitUntil: 'networkidle0', timeout: 60000 });

        // Wait for Flutter web to fully initialize
        await page.waitForFunction(() => document.querySelector('flutter-view'), { timeout: 60000 });
        await new Promise(resolve => setTimeout(resolve, 5000));

        console.log('Taking screenshot of Home Tab');
        await page.screenshot({ path: 'home.png' });

        // Navigate to Rooms tab
        await page.goto('http://localhost:8080/rooms', { waitUntil: 'networkidle0' });
        await new Promise(resolve => setTimeout(resolve, 3000));
        console.log('Taking screenshot of Rooms Tab');
        await page.screenshot({ path: 'rooms.png' });

        // Navigate to Game Room
        await page.goto('http://localhost:8080/room/123', { waitUntil: 'networkidle0' });
        await new Promise(resolve => setTimeout(resolve, 3000));
        console.log('Taking screenshot of Game Room');
        await page.screenshot({ path: 'game_room.png' });

        await browser.close();
        console.log('Screenshots taken successfully');

    } catch (error) {
        console.error('Error:', error);
    } finally {
        server.close();
        process.exit();
    }
});
