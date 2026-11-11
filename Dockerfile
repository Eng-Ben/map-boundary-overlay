# Container image for the home server (ghcr.io/eng-ben/map-boundary-overlay).
# Stage 1 builds the static app with Node 26 (same major as .nvmrc) and BASE_PATH=/.
# Stage 2 serves dist/ with nginx running as a non-root user on port 8080.
# Only the built files and the nginx config reach the final image.

FROM node:26-alpine AS build
WORKDIR /app
COPY package.json package-lock.json .npmrc ./
RUN npm ci
COPY . .
ARG BASE_PATH=/
ENV BASE_PATH=$BASE_PATH
RUN npm run build

FROM nginx/nginx-unprivileged:1.30-alpine
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
USER 101
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1:8080/healthz || exit 1
