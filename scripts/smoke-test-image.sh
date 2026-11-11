#!/usr/bin/env bash
# Smoke test for the container image. Used by image.yml on pull requests and
# again before publishing, so the pushed image is always the tested one.
# Starts the container hardened like on the home server (read-only filesystem,
# no capabilities, no-new-privileges, 300 MB memory limit) and checks:
#   /healthz, /, client-side fallback, 404 for missing assets, every file
#   referenced by index.html, no-cache on index.html, non-root user and
#   memory use below the limit.
# Usage: scripts/smoke-test-image.sh <image>
set -euo pipefail

image="$1"
name="smoke-test"
port=8080
max_mib="${MAX_MEMORY_MIB:-300}"
base="http://localhost:${port}"

cleanup() {
  echo "--- container logs ---"
  docker logs "$name" 2>&1 || true
  docker rm -f "$name" >/dev/null 2>&1 || true
}
trap cleanup EXIT

docker run -d --name "$name" -p "${port}:8080" \
  --read-only --tmpfs /tmp \
  --cap-drop ALL --security-opt no-new-privileges \
  --memory "${max_mib}m" \
  "$image"

for _ in $(seq 1 30); do
  if curl -fsS "${base}/healthz" >/dev/null 2>&1; then break; fi
  sleep 1
done

check_status() {
  local expected="$1" path="$2" actual
  actual=$(curl -s -o /dev/null -w '%{http_code}' "${base}${path}")
  if [ "$actual" != "$expected" ]; then
    echo "FAIL ${path}: expected ${expected}, got ${actual}"
    exit 1
  fi
  echo "ok   ${path} -> ${actual}"
}

check_status 200 /healthz
check_status 200 /
check_status 200 /some/client/route
check_status 404 /assets/does-not-exist.js

for asset in $(curl -fsS "${base}/" | grep -oE '(src|href)="/[^"]+"' | sed -E 's/^(src|href)="//; s/"$//'); do
  check_status 200 "$asset"
done

if ! curl -sI "${base}/" | grep -qi '^cache-control: no-cache'; then
  echo "FAIL /: missing Cache-Control: no-cache"
  exit 1
fi
echo "ok   / has Cache-Control: no-cache"

uid=$(docker exec "$name" id -u)
if [ "$uid" = "0" ]; then
  echo "FAIL container runs as root"
  exit 1
fi
echo "ok   runs as user id ${uid}"

sleep 2
bytes=$(docker exec "$name" cat /sys/fs/cgroup/memory.current)
mib=$((bytes / 1024 / 1024))
echo "memory: ${mib} MiB (limit ${max_mib} MiB)"
if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  echo "Memory after start: ${mib} MiB of ${max_mib} MiB" >> "$GITHUB_STEP_SUMMARY"
fi
if [ "$mib" -ge "$max_mib" ]; then
  echo "FAIL memory use is above the limit"
  exit 1
fi
