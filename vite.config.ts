// Vite build and Vitest test configuration.
// BASE_PATH sets the public base path at build time:
//   "/" for the home server image (default), "/map-boundary-overlay/" for GitHub Pages.
// The same variable will also drive the PWA manifest and service worker scope (M5).
// Unit tests live next to the code in src/ (*.test.ts / *.test.tsx).
// End-to-end tests live in e2e/ and are run by Playwright, not Vitest.
import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react";

const basePath = process.env.BASE_PATH ?? "/";

// Fail the build early on a malformed base path instead of shipping broken asset URLs.
if (!/^\/([\w.-]+\/)*$/.test(basePath)) {
  throw new Error(`BASE_PATH must start and end with "/", got "${basePath}"`);
}

export default defineConfig({
  base: basePath,
  plugins: [react()],
  test: {
    include: ["src/**/*.test.{ts,tsx}"],
    environment: "node",
  },
});
