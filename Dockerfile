FROM alpine:latest

RUN apk add --no-cache iperf3 \
  && adduser -S iperf

USER iperf
    
EXPOSE 5201/tcp 5201/udp

ENTRYPOINT ["iperf3"]

HEALTHCHECK --timeout=3s \
 CMD iperf3 -k 1 -c 127.0.0.1 || exit 1

CMD ["-s"]