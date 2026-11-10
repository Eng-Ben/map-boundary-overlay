// Playwright end-to-end test configuration.
// Tests in e2e/ run against the production build served by `vite preview`,
// so they exercise the same files that are published.
// BASE_PATH is passed through to the build, and the preview server serves the app
// under that path, so the same tests cover both "/" and "/map-boundary-overlay/".
// Only Chromium for now; real iPhone behaviour is checked manually in field tests.
import { defineConfig, devices } from "@playwright/test";

const port = 4173;
const basePath = process.env.BASE_PATH ?? "/";
const baseURL = `http://localhost:${port}${basePath}`;

export default defineConfig({
  testDir: "e2e",
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 1 : 0,
  reporter: process.env.CI ? "github" : "list",
  use: {
    baseURL,
  },
  projects: [{ name: "chromium", use: { ...devices["Desktop Chrome"] } }],
  webServer: {
    command: `npm run build && npm run preview -- --port ${port} --strictPort`,
    url: baseURL,
    reuseExistingServer: !process.env.CI,
  },
});
