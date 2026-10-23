# docker-iperf3

Minimal, lightweight [iperf3](https://iperf.fr/) Docker image based on Alpine Linux, for network throughput testing (TCP/UDP bandwidth, jitter, packet loss).

- **Base image**: `alpine:latest`
- **Runs as**: non-root user (`iperf`)
- **Exposed port**: `5201/tcp` and `5201/udp`
- **Healthcheck**: built-in, pings itself with `iperf3 -k 1 -c 127.0.0.1`
- **Default command**: runs as a server (`iperf3 -s`)

## Image

```
registry.bldwebagency.fr/docker-iperf3:latest
```

## How to use

### Run as a server (default)

```bash
docker run -d --name iperf3-server -p 5201:5201/tcp -p 5201:5201/udp registry.bldwebagency.fr/docker-iperf3:latest
```

This is equivalent to running `iperf3 -s` inside the container.

### Run as a client

Point the client at your server (container, host, or remote):

```bash
docker run --rm registry.bldwebagency.fr/docker-iperf3:latest -c <SERVER_IP> -t 10
```

Any `iperf3` flag can be passed after the image name, since the entrypoint is `iperf3` itself.

### docker-compose example

```yaml
services:
  iperf3-server:
    image: registry.bldwebagency.fr/docker-iperf3:latest
    ports:
      - "5201:5201/tcp"
      - "5201:5201/udp"
    restart: unless-stopped
```

## Examples

**Basic TCP throughput test (10s)**

```bash
docker run --rm registry.bldwebagency.fr/docker-iperf3:latest -c <SERVER_IP> -t 10
```

**UDP test with 100 Mbps target bandwidth**

```bash
docker run --rm registry.bldwebagency.fr/docker-iperf3:latest -c <SERVER_IP> -u -b 100M
```

**Reverse mode (server sends, client receives)**

```bash
docker run --rm registry.bldwebagency.fr/docker-iperf3:latest -c <SERVER_IP> -R
```

**Parallel streams**

```bash
docker run --rm registry.bldwebagency.fr/docker-iperf3:latest -c <SERVER_IP> -P 4
```

**JSON output**

```bash
docker run --rm registry.bldwebagency.fr/docker-iperf3:latest -c <SERVER_IP> -J
```

## Build locally

```bash
docker build -t docker-iperf3 .
docker run -d -p 5201:5201/tcp -p 5201:5201/udp docker-iperf3
```

## Notes

- Container runs as a non-root user for security.
- Healthcheck loops back to `127.0.0.1`, so it only validates that the `iperf3` process is alive/listening — not external connectivity.

## Development

No CI: tests, build and push are done locally.

```bash
./scripts/test.sh        # build + server/client/healthcheck tests (Docker)
./scripts/build-push.sh  # build linux/amd64 and push :latest (+ version tag if HEAD is tagged)
```
