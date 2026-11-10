# 003. GitHub Pages and GHCR image from one build with BASE_PATH

- Status: Accepted
- Date: 2026-11-10

## Context

GPS and PWA features require HTTPS. A public demo is needed without buying a domain, and the app should also run on the home server like the other portfolio apps. GitHub Pages serves the app under `/map-boundary-overlay/`, while the home server serves each app at `/` on its own port.

## Decision

Use one `BASE_PATH` build variable that controls the Vite base, the manifest `start_url` and `scope`, and the service worker scope.

- GitHub Pages: `BASE_PATH=/map-boundary-overlay/`, published by `pages.yml` on push to `main`.
- Home server: `BASE_PATH=/`, published as a non-root nginx image on port 8080 to `ghcr.io/eng-ben/map-boundary-overlay` by `image.yml`.

## Consequences

- One codebase and one build process for both targets.
- Both base paths must be tested, especially for the service worker.
- Each address has its own browser storage, so users should stick to one address in the field.
- The nginx image adds `/healthz`, a fallback to `index.html` and no caching for `index.html`, `sw.js` and the manifest.
