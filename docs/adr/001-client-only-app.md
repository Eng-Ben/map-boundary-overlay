# 001. Client-only app without a backend

- Status: Accepted
- Date: 2026-11-10

## Context

Users upload map images and use their GPS position in the field. Both are personal data. The home server is weak hardware, and a public demo should be cheap and safe to run.

## Decision

Build a client-only progressive web app. Images and map projects are stored in the browser (IndexedDB). The GPS position is kept in memory only. There are no accounts, no analytics and no backend.

## Consequences

- Personal data never leaves the device, apart from tile requests to Kartverket.
- The app can be hosted as static files on GitHub Pages and in a small nginx container.
- No sync or sharing between devices; deleting browser data deletes the user's maps.
- Browser storage limits apply (iPhone behaviour needs verification).
