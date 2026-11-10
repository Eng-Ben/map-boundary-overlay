// Vite build and Vitest test configuration.
// Unit tests live next to the code in src/ (*.test.ts / *.test.tsx).
// End-to-end tests live in e2e/ and are run by Playwright, not Vitest.
// The base path (BASE_PATH) for GitHub Pages and the home server is added in a later PR.
import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  test: {
    include: ["src/**/*.test.{ts,tsx}"],
    environment: "node",
  },
});
