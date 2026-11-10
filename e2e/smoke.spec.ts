// Smoke test: the built app loads and React renders something into #root.
// Uses a relative path ("./") so it follows the configured base path.
// Catches broken builds, wrong base paths and missing assets early.
import { expect, test } from "@playwright/test";

test("app loads and renders", async ({ page }) => {
  await page.goto("./");
  await expect(page.locator("#root")).not.toBeEmpty();
});
