# 004. End-to-end tests run in CI only

- Status: Accepted
- Date: 2026-11-10

## Context

The development machine is an Intel Mac on macOS 13. Playwright 1.65 does not support its browsers on macOS 13 (`npx playwright install chromium` fails).

## Decision

Run Playwright end-to-end tests only in CI on Linux. Locally, run lint, type checking, formatting checks, unit tests and the dev server. Type checking still covers the Playwright files.

## Consequences

- No extra tools (such as Docker) or outdated Playwright versions are needed.
- End-to-end failures are only seen after pushing a branch, so e2e tests are kept few and simple.
- Revisit if the development machine changes, or run Playwright in Docker if local e2e becomes necessary.
