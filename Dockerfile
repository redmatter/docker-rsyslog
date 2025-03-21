FROM debian:bookworm-slim

RUN ( \
    export DEBIAN_FRONTEND=noninteractive; \
    export BUILD_DEPS=""; \
    export APP_DEPS="rsyslog rsyslog-elasticsearch rsyslog-gnutls"; \
    set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ${APP_DEPS} ${BUILD_DEPS}; \
    #apt-get remove -y $BUILD_DEPS; \
    apt-get clean autoclean; \
    apt-get autoremove --yes; \
    rm -rf /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log; \
)

COPY rsyslog.conf /etc/
COPY rsyslog.d/*.conf /etc/rsyslog.d/

ENV TZ=UTC

VOLUME ["/var/log"]

# UDP listen port
EXPOSE 514/udp

CMD ["/usr/sbin/rsyslogd", "-n"]

# vim: tabstop=4 shiftwidth=4 expandtab:
