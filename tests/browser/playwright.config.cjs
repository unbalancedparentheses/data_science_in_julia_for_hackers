const { defineConfig } = require('@playwright/test');

module.exports = defineConfig({
  testDir: '.',
  testMatch: '*.spec.cjs',
  workers: 1,
  timeout: 30_000,
  globalTimeout: 180_000,
  use: {
    baseURL: 'http://127.0.0.1:8768',
    browserName: 'chromium',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
  },
  webServer: {
    command: 'python3 -m http.server 8768 --bind 127.0.0.1 --directory ../../docs',
    cwd: __dirname,
    url: 'http://127.0.0.1:8768',
    reuseExistingServer: !process.env.CI,
    timeout: 15_000,
  },
});
