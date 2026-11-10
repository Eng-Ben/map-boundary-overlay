# 002. Affine georeferencing in Web Mercator

- Status: Accepted
- Date: 2026-11-10

## Context

A user-supplied map image must be placed on the base map from a few points the user marks on both. The method must be simple to test, work with three or more points, and be shown with an honest error estimate.

## Decision

Fit a 6-parameter affine transform with least squares, from image pixels to Web Mercator metres. Pass the four transformed image corners to MapLibre's image source. Show leave-one-out error in metres (scaled by cos(latitude)) from four points, and reject nearly collinear points.

## Consequences

- An affine transform always yields a parallelogram, so MapLibre's experimental warping is not needed.
- Model error grows with map size, roughly 2–3 m at 5 km and 27–42 m at 20 km (needs verification against a projection library). The app warns above about 20 km.
- Non-linear fits (for example for scanned or distorted maps) are out of scope for v0.1.0.
- The fitting code lives in `src/core/` as pure TypeScript and is unit tested in Node.
