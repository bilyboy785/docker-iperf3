# docker-iperf3

Workflow (no GitHub CI, never add GitHub Actions):

1. For each new feature: run `./scripts/test.sh` (local Docker tests).
2. Build and push with `./scripts/build-push.sh` to `registry.bldwebagency.fr/docker-iperf3:latest`
   (linux/amd64 + linux/arm64) + version tag if HEAD is on a git tag (`VERSION=x.y.z` to override).
3. Always commit and push; create a GitHub release (`gh release create vX.Y.Z`) when relevant,
   then run `build-push.sh` on the tagged commit so the version tag is pushed too.
