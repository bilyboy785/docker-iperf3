#!/usr/bin/env bash
# Build the amd64 image and push it to the private registry as :latest,
# plus a version tag when HEAD is on a git tag (or VERSION is provided).
set -euo pipefail

cd "$(dirname "$0")/.."

PROJECT="docker-iperf3"
IMAGE="registry.bldwebagency.fr/${PROJECT}"

VERSION="${VERSION:-$(git describe --tags --exact-match 2>/dev/null || true)}"
VERSION="${VERSION#v}"

TAGS=(-t "${IMAGE}:latest")
[ -n "$VERSION" ] && TAGS+=(-t "${IMAGE}:${VERSION}")

docker buildx build --platform linux/amd64 "${TAGS[@]}" --push .

echo "Pushed ${IMAGE}:latest${VERSION:+ and ${IMAGE}:${VERSION}}"
