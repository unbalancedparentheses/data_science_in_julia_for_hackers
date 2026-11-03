const { test, expect } = require('@playwright/test');

const demos = [
  ['mars', 'escaping-from-mars'],
  ['evaluation', 'model-evaluation'],
  ['tabular', 'tabular-learning'],
  ['causal', 'causal-inference'],
  ['bayesian', 'bayesian-workflow'],
];

function recordErrors(page) {
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  page.on('response', response => {
    if (response.url().includes('/interactive/') && response.status() >= 400) {
      errors.push(`${response.status()} ${response.url()}`);
    }
  });
  return errors;
}

async function ready(surface) {
  await expect(surface.locator('[data-demo-results]')).toBeVisible();
  await expect(surface.locator('[data-demo-results]')).not.toHaveText('');
  await expect(surface.locator('svg').first()).toBeVisible();
}

async function change(control) {
  if (await control.evaluate(element => element.tagName === 'SELECT')) {
    const current = await control.inputValue();
    const values = await control.locator('option').evaluateAll(options => options.map(option => option.value));
    await control.selectOption(values.find(value => value !== current));
  } else {
    const current = await control.inputValue();
    const minimum = await control.getAttribute('min');
    await control.focus();
    await control.press(Number(current) === Number(minimum) ? 'End' : 'Home');
    await expect(control).not.toHaveValue(current);
  }
}

for (const [slug, chapter] of demos) {
  test(`${slug}: every control changes the calculated result`, async ({ page }) => {
    const errors = recordErrors(page);
    // The standalone demonstrations must work without any external runtime/CDN.
    await page.route(/^https?:\/\/(?!127\.0\.0\.1:8768\/)/, route => route.abort());
    await page.goto(`/interactive/${slug}/index.html`, { waitUntil: 'networkidle' });
    await ready(page);
    const controls = page.locator('input[type="range"], select');
    const count = await controls.count();
    expect(count).toBeGreaterThan(0);
    for (let index = 0; index < count; index++) {
      if (index) {
        await page.reload({ waitUntil: 'networkidle' });
        await ready(page);
      }
      const results = page.locator('[data-demo-results]');
      const before = await results.innerHTML();
      const chartsBefore = await page.locator('svg').evaluateAll(elements => elements.map(element => element.innerHTML));
      await change(controls.nth(index));
      await expect.poll(() => results.innerHTML()).not.toBe(before);
      await expect.poll(() => page.locator('svg').evaluateAll(elements => elements.map(element => element.innerHTML))).not.toEqual(chartsBefore);
    }
    expect(errors).toEqual([]);
  });

  test(`${slug}: readable at phone width`, async ({ page }) => {
    const errors = recordErrors(page);
    await page.setViewportSize({ width: 390, height: 844 });
    await page.goto(`/interactive/${slug}/index.html`, { waitUntil: 'networkidle' });
    await ready(page);
    expect(await page.evaluate(() => document.documentElement.scrollWidth)).toBeLessThanOrEqual(391);
    for (const chart of await page.locator('svg').all()) {
      const box = await chart.boundingBox();
      expect(box.width).toBeGreaterThan(200);
      expect(box.x + box.width).toBeLessThanOrEqual(391);
    }
    for (const label of await page.locator('svg text').all()) {
      const pixels = await label.evaluate(element => {
        const transform = element.getScreenCTM();
        return parseFloat(getComputedStyle(element).fontSize) * Math.hypot(transform.a, transform.b);
      });
      expect(pixels).toBeGreaterThanOrEqual(10);
    }
    expect(errors).toEqual([]);
  });

  test(`${slug}: works inside its published chapter`, async ({ page }) => {
    const errors = recordErrors(page);
    // Legacy MathJax/CDN availability is independent of these local demo assets.
    await page.route(/^https?:\/\/(?!127\.0\.0\.1:8768\/)/, route => route.abort());
    await page.goto(`/${chapter}.html`, { waitUntil: 'domcontentloaded' });
    const selector = `iframe[data-interactive][src="interactive/${slug}/index.html"]`;
    const element = page.locator(selector);
    await element.scrollIntoViewIfNeeded();
    const frame = page.frameLocator(selector);
    await ready(frame);
    for (const link of await frame.locator('a').all()) {
      await expect(link).toHaveAttribute('target', /^(?:_top|_blank)$/);
    }
    const results = frame.locator('[data-demo-results]');
    const before = await results.innerHTML();
    await change(frame.locator('input[type="range"], select').first());
    await expect.poll(() => results.innerHTML()).not.toBe(before);
    // Native details must remain keyboard-operable and resize the chapter
    // iframe in both directions, rather than leaving an oversized empty panel.
    for (const details of await frame.locator('details').all()) {
      const summary = details.locator('summary').first();
      const height = await element.evaluate(frame => frame.clientHeight);
      await summary.focus();
      await summary.press('Enter');
      await expect(details).toHaveAttribute('open', '');
      await expect.poll(() => element.evaluate(frame => frame.clientHeight)).toBeGreaterThan(height + 10);
      await summary.press('Enter');
      await expect(details).not.toHaveAttribute('open', '');
      await expect.poll(async () => Math.abs(await element.evaluate(frame => frame.clientHeight) - height)).toBeLessThanOrEqual(3);
    }
    for (const label of await frame.locator('svg text').all()) {
      const pixels = await label.evaluate(element => {
        const transform = element.getScreenCTM();
        return parseFloat(getComputedStyle(element).fontSize) * Math.hypot(transform.a, transform.b);
      });
      expect(pixels).toBeGreaterThanOrEqual(10);
    }
    expect(errors).toEqual([]);
  });
}
