FROM debian:stable

RUN ( \
    export DEBIAN_FRONTEND=noninteractive; \

    set -e -u -x; \

    apt-get update; \
    apt-get install -y --no-install-recommends \
        rsyslog \
        rsyslog-elasticsearch \
        rsyslog-gnutls \
        ; \

    apt-get clean autoclean; \
    apt-get autoremove --yes; \
    rm -rf /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log; \
)

COPY rsyslog.conf /etc/
COPY rsyslog.d/*.conf /etc/rsyslog.d/

VOLUME ["/var/log"]

# UDP listen port
EXPOSE 514 514/udp

CMD ["/usr/sbin/rsyslogd", "-n"]

# vim: tabstop=4 shiftwidth=4 expandtab:
