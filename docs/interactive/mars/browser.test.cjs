// npm ci --prefix tests/browser; then node docs/interactive/mars/browser.test.cjs
'use strict';
const { chromium } = require('../../../tests/browser/node_modules/playwright');
const assert = require('node:assert/strict');
const { pathToFileURL } = require('node:url');
const path = require('node:path');
const os = require('node:os');
(async () => {
  const browser = await chromium.launch({headless: true});
  try {
    const page = await browser.newPage({viewport: {width: 390, height: 900}});
    const errors = [];
    page.on('pageerror', error => errors.push(error.message));
    await page.goto(pathToFileURL(path.join(__dirname, 'index.html')).href);
    await page.waitForFunction(() => document.getElementById('result').textContent.includes('63.9%'));
    const original = await page.locator('#result').textContent();
    await page.getByRole('slider', {name: /Shared angle uncertainty/}).focus();
    await page.keyboard.press('Home');
    assert.notEqual(await page.locator('#result').textContent(), original);
    const knownAngle = await page.locator('#result').textContent();
    await page.getByRole('slider', {name: /Range-error standard deviation/}).focus();
    await page.keyboard.press('End');
    assert.notEqual(await page.locator('#result').textContent(), knownAngle);
    const beforeBudget = await page.locator('#density').getAttribute('d');
    const beforeBudgetText = await page.locator('#result').textContent();
    await page.getByRole('slider', {name: /Hypothetical speed budget/}).focus();
    await page.keyboard.press('Home');
    assert.notEqual(await page.locator('#result').textContent(), beforeBudgetText);
    assert.equal(await page.locator('#density').getAttribute('d'), beforeBudget);
    assert.ok(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth));
    await page.getByRole('button', {name: 'Reset experiment'}).click();
    await page.waitForFunction(() => document.getElementById('result').textContent.includes('63.9%'));
    assert.equal(await page.locator('#result').textContent(), original);
    assert.deepEqual(errors, []);
    await page.screenshot({path: path.join(os.tmpdir(), 'mars-browser-mobile.png'), fullPage: true});
    await page.setViewportSize({width: 1000, height: 1000});
    await page.screenshot({path: path.join(os.tmpdir(), 'mars-browser-desktop.png'), fullPage: true});
    console.log('Mars browser: all three keyboard controls, budget-only chart stability, reset, mobile overflow and runtime errors checked.');
  } finally { await browser.close(); }
})().catch(error => { console.error(error); process.exitCode = 1; });
