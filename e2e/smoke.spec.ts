// Smoke test: the built app loads, React renders into #root, and no request
// fails or returns an error status. Uses a relative path ("./") so it follows
// the configured base path. Catches broken builds, wrong base paths and
// missing assets, such as public files referenced with a hard-coded "/".
import { expect, test } from "@playwright/test";

test("app loads without missing files", async ({ page }) => {
  const failures: string[] = [];
  page.on("response", (response) => {
    if (response.status() >= 400) {
      failures.push(`${response.status()} ${response.url()}`);
    }
  });
  page.on("requestfailed", (request) => {
    failures.push(`failed ${request.url()}`);
  });

  await page.goto("./");
  await expect(page.locator("#root")).not.toBeEmpty();
  await page.waitForLoadState("networkidle");

  expect(failures).toEqual([]);
});
