# Syslog from docker containers

When migrating legacy applications, it is common to have issues with syslog capability of the container. On a typical
linux host / VM, there will be a syslog service that provides this functionality.

A syslog service would typically create and service a UNIX socket located at `/dev/log`. An application can then call [
`syslog(3)`](http://linux.die.net/man/3/syslog) function to write log messages to the socket. In order to resolve the
syslog problem with containerised applications, what we need to do is to setup a working `/dev/log` socket to which
applications can write.

The `redmatter/rsyslog` docker image helps you with this solution.

# How do I set it up?

If you understand `docker-compose` YAML, then go ahead and have a look at [
`docker-compose.example.yml`](docker-compose.example.yml).

The `rsyslog` container created from `redmatter/rsyslog` docker image is configured to listen on an additional socket
within the container at `/var/run/rsyslog/dev/log`. In order to expose this socket to other containers, you need to
ensure this container's `/var/run/rsyslog/dev` directory is mounted via a volume.

    docker run -d --name syslog -v /tmp/rsyslog:/var/run/rsyslog/dev redmatter/rsyslog

The command above will start up the rsyslog daemon in `syslog` container which will result in the socket being created
at `/tmp/rsyslog/log`.

To share this socket to another container, you need to volume mount just the socket as `/dev/log`.

    docker run -it --rm -v /tmp/rsyslog/log:/dev/log busybox

Now, if you log some messages from the `busybox` container, you will be able to see these logged into
`/var/log/messages` on the `syslog` container.

    / # logger "Test message"
    / # exit

In order to inspect the messages, you can spin up another container in another terminal; you can see the message.

    / # docker run -it --rm --volumes-from=syslog busybox tail /var/log/messages
    
    Mar  3 19:21:04 eb40accfee71 root: Test message

# Surviving restarts

If using the above approach, where the socket is mounted directly to `/dev/log`, it is important that the rsyslog
container is always started and has created its socket before any client container starts.
If a client container is started before the socket has been created, the path which Docker is told to mount into the
container at `/dev/log` won't yet exist, so Docker will create a directory there instead; in the example above, this
will result in `/tmp/rsyslog/log` becoming a directory. When rsyslog starts and attempts to create its socket at
`/var/run/rsyslog/dev/log`, this will fail, as a directory is already present at that location.

If using Docker Compose, `depends_on` can be used to ensure that the client container always starts after the rsyslog
container (though it should be noted that it makes no guarantee that the rsyslog container will have created its socket
in time). However, when the Docker daemon itself is restarted, it doesn't appear to honour the startup order previously
imposed by Docker Compose, so it's possible that the client container is started before rsyslog. In this case, rsyslog
fails to initialise.

To work around this, the client container can mount the parent directory of the socket, rather than the socket itself.
As `/dev` is a system directory it's best not to mount this from a volume, so instead we should mount the rsyslog
directory to somewhere else and use a symlink from `/dev/log` to the socket within the mounted directory. This can be
done in a wrapper script; creating the symlink during build will not work as `/dev` is a 'special' directory.

# What next?

Configure rsyslog to forward messages to another server / service. The image comes with elasticsearch module which can
be used to forward messages to ELK stack.

**IMPORTANT:** For heavy loads or production deployments, you must configure it to not log to disk (
`/var/log/messages`).

# Caveats

- You will lose the hostname information of the logging application. The hostname that appears in the log will always be
  that of the `syslog` container, which is a meaningless hash created by docker (the container ID). You may
  consider [rsyslog property replacer](http://www.rsyslog.com/doc/v8-stable/configuration/property_replacer.html) to
  help you with this.
- The `redmatter/rsyslog` is by default configured to log to `/var/log/messages`. This can get out of hand if you use it
  as is in heavy load production environments, as there is no `logrotate` functionality. Have a look at [
  `forward.conf.example`](forward.conf.example) in order to configure rsyslog to forward all messages to another host.
  You may also use [
  `elasticsearch` module](http://www.rsyslog.com/doc/v8-stable/configuration/modules/omelasticsearch.html) to forward
  messages to ELK stack (though it will make logstash redundant).

# Bedtime reading

- https://jpetazzo.github.io/2014/08/24/syslog-docker/
- https://blog.logentries.com/2014/03/how-to-run-rsyslog-in-a-docker-container-for-logging/
- https://github.com/helderco/docker-rsyslog
