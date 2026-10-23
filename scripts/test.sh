#!/usr/bin/env bash
# Local tests: build the image (amd64) and check server, client and healthcheck.
set -euo pipefail

cd "$(dirname "$0")/.."

IMAGE="docker-iperf3:test"
NETWORK="iperf3-test-net"
SERVER="iperf3-test-server"

cleanup() {
  docker rm -f "$SERVER" >/dev/null 2>&1 || true
  docker network rm "$NETWORK" >/dev/null 2>&1 || true
}
trap cleanup EXIT
cleanup

echo "==> Build"
docker build --platform linux/amd64 -t "$IMAGE" .

echo "==> Version"
docker run --rm --platform linux/amd64 "$IMAGE" --version

echo "==> Non-root user"
[ "$(docker run --rm --platform linux/amd64 --entrypoint id "$IMAGE" -u)" != "0" ]

echo "==> Server + client"
docker network create "$NETWORK" >/dev/null
docker run -d --platform linux/amd64 --name "$SERVER" --network "$NETWORK" "$IMAGE" >/dev/null
sleep 2
docker run --rm --platform linux/amd64 --network "$NETWORK" "$IMAGE" -c "$SERVER" -t 2

echo "==> Healthcheck"
for _ in $(seq 1 15); do
  status="$(docker inspect -f '{{.State.Health.Status}}' "$SERVER")"
  [ "$status" = "healthy" ] && break
  sleep 2
done
[ "$status" = "healthy" ] || { echo "healthcheck status: $status"; exit 1; }

echo "All tests passed"
