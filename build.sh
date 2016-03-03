#!/bin/bash

set -e -u -x;

: ${IMAGE_TAG:=redmatter/rsyslog}

export DEBIAN_FRONTEND=noninteractive;
apt-get update;
# apt-get -y upgrade;
apt-get install -y --no-install-recommends \
	rsync \
	rsyslog rsyslog-elasticsearch rsyslog-gnutls \
	# busybox-static

build_temp_dir=/dockerized

# get Dockerize to create the basic skeleton that can be worked with
dockerize --output-dir $build_temp_dir -n \
	-t ${IMAGE_TAG} \
	-L copy-unsafe \
	-e '/usr/sbin/rsyslogd -n' \
	/usr/sbin/rsyslogd \
	/usr/lib/rsyslog/imfile.so \
	/usr/lib/rsyslog/imkmsg.so \
	/usr/lib/rsyslog/immark.so \
	/usr/lib/rsyslog/impstats.so \
	/usr/lib/rsyslog/imptcp.so \
	/usr/lib/rsyslog/imtcp.so \
	/usr/lib/rsyslog/imudp.so \
	/usr/lib/rsyslog/imuxsock.so \
	/usr/lib/rsyslog/lmnet.so \
	/usr/lib/rsyslog/lmnetstrms.so \
	/usr/lib/rsyslog/lmnsd_ptcp.so \
	/usr/lib/rsyslog/lmregexp.so \
	/usr/lib/rsyslog/lmstrmsrv.so \
	/usr/lib/rsyslog/lmtcpclt.so \
	/usr/lib/rsyslog/lmtcpsrv.so \
	/usr/lib/rsyslog/lmzlibw.so \
	/usr/lib/rsyslog/mmanon.so \
	/usr/lib/rsyslog/mmexternal.so \
	/usr/lib/rsyslog/mmjsonparse.so \
	/usr/lib/rsyslog/mmnormalize.so \
	/usr/lib/rsyslog/mmpstrucdata.so \
	/usr/lib/rsyslog/mmsequence.so \
	/usr/lib/rsyslog/mmutf8fix.so \
	/usr/lib/rsyslog/ommail.so \
	/usr/lib/rsyslog/omprog.so \
	/usr/lib/rsyslog/omuxsock.so \
	/usr/lib/rsyslog/pmaixforwardedfrom.so \
	/usr/lib/rsyslog/pmcisconames.so \
	/usr/lib/rsyslog/pmlastmsg.so \
	/usr/lib/rsyslog/pmrfc3164sd.so \
	/usr/lib/rsyslog/pmsnare.so \
	/usr/lib/rsyslog/omelasticsearch.so \
	/usr/lib/rsyslog/lmnsd_gtls.so \
	\
	/usr/lib/x86_64-linux-gnu/libcurl-gnutls.so.4 \
	/usr/lib/x86_64-linux-gnu/libcurl-gnutls.so.4.3.0 \
	/usr/lib/x86_64-linux-gnu/liblognorm.so.1 \
	/usr/lib/x86_64-linux-gnu/liblognorm.so.1.0.0 \
	/usr/lib/x86_64-linux-gnu/libgnutls-deb0.so.28 \
	/usr/lib/x86_64-linux-gnu/libgnutls-deb0.so.28.41.0 \
	/usr/lib/x86_64-linux-gnu/libp11-kit.so.0 \
	/usr/lib/x86_64-linux-gnu/libp11-kit.so.0.0.0 \
	/lib/x86_64-linux-gnu/libm.so.6 \
	/lib/x86_64-linux-gnu/libm-2.19.so \
	/usr/lib/x86_64-linux-gnu/libtasn1.so.6 \
	/usr/lib/x86_64-linux-gnu/libtasn1.so.6.3.2 \
	/usr/lib/x86_64-linux-gnu/libnettle.so.4 \
	/usr/lib/x86_64-linux-gnu/libnettle.so.4.7 \
	/usr/lib/x86_64-linux-gnu/libidn.so.11 \
	/usr/lib/x86_64-linux-gnu/libidn.so.11.6.12 \
	/usr/lib/x86_64-linux-gnu/libhogweed.so.2 \
	/usr/lib/x86_64-linux-gnu/libhogweed.so.2.5 \
	/usr/lib/x86_64-linux-gnu/librtmp.so.1 \
	/usr/lib/x86_64-linux-gnu/libgmp.so.10 \
	/usr/lib/x86_64-linux-gnu/libgmp.so.10.2.0 \
	/usr/lib/x86_64-linux-gnu/libssh2.so.1 \
	/usr/lib/x86_64-linux-gnu/libssh2.so.1.0.1 \
	/usr/lib/x86_64-linux-gnu/libffi.so.6 \
	/usr/lib/x86_64-linux-gnu/libffi.so.6.0.2 \
	/usr/lib/x86_64-linux-gnu/libgssapi_krb5.so.2 \
	/usr/lib/x86_64-linux-gnu/libgssapi_krb5.so.2.2 \
	/usr/lib/x86_64-linux-gnu/libkrb5.so.3 \
	/usr/lib/x86_64-linux-gnu/libkrb5.so.3.3 \
	/usr/lib/x86_64-linux-gnu/libk5crypto.so.3 \
	/usr/lib/x86_64-linux-gnu/libk5crypto.so.3.1 \
	/lib/x86_64-linux-gnu/libcom_err.so.2 \
	/lib/x86_64-linux-gnu/libcom_err.so.2.1 \
	/usr/lib/x86_64-linux-gnu/liblber-2.4.so.2 \
	/usr/lib/x86_64-linux-gnu/liblber-2.4.so.2.10.3 \
	/usr/lib/x86_64-linux-gnu/libldap_r-2.4.so.2 \
	/usr/lib/x86_64-linux-gnu/libldap_r-2.4.so.2.10.3 \
	/lib/x86_64-linux-gnu/libgcrypt.so.20 \
	/lib/x86_64-linux-gnu/libgcrypt.so.20.0.3 \
	/usr/lib/x86_64-linux-gnu/libkrb5support.so.0 \
	/usr/lib/x86_64-linux-gnu/libkrb5support.so.0.1 \
	/lib/x86_64-linux-gnu/libkeyutils.so.1 \
	/lib/x86_64-linux-gnu/libkeyutils.so.1.5 \
	/lib/x86_64-linux-gnu/libresolv.so.2 \
	/lib/x86_64-linux-gnu/libresolv-2.19.so \
	/usr/lib/x86_64-linux-gnu/libsasl2.so.2 \
	/usr/lib/x86_64-linux-gnu/libsasl2.so.2.0.25 \
	/lib/x86_64-linux-gnu/libgpg-error.so.0 \
	/lib/x86_64-linux-gnu/libgpg-error.so.0.13.0 \
	\
	/lib/x86_64-linux-gnu/libgcc_s.so.1 \
	# \
	# /bin/busybox

	# /usr/lib/rsyslog/imklog.so \

cd $build_temp_dir

mkdir -p var/run var/spool/rsyslog var/log
chmod go-rwx var/spool/rsyslog
cp /build/rsyslog.conf etc/rsyslog.conf
cp -r /build/rsyslog.d etc/.

if [ -x /bin/busybox ]; then
	cd bin; /bin/busybox --list | while read cmd; do ln -s busybox "$cmd"; done
fi

cd $build_temp_dir
echo "VOLUME [\"/var/log\"]" >> Dockerfile
docker build -t ${IMAGE_TAG} .

rm -rf $build_temp_dir
