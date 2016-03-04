# Syslog from docker containers

When migrating legacy applications, it is common to have issues with syslog capability of the container. On a typical linux host / VM, there will be a syslog service that provides this functionality.

A syslog service would typically create and service a UNIX socket located at `/dev/log`. An application can then call [`syslog(3)`](http://linux.die.net/man/3/syslog) function to write log messages to the socket. In order to resolve the syslog problem with containerised applications, what we need to do is to setup a working `/dev/log` socket to which applications can write.

The `redmatter/rsyslog` docker image helps you with this solution.

# How do I set it up?

If you understand `docker-compose` YAML, then go ahead and have a look at [`docker-compose.example.yml`](docker-compose.example.yml).

The `rsyslog` container created from `redmatter/rsyslog` docker image is configured to listen on an additional socket within the container at `/rsyslog/imuxsock`. In order to expose this socket to other containers, you need to pass in a path on the host as volume for `/rsyslog`.

    docker run -d --name syslog -v /tmp/rsyslog:/rsyslog redmatter/rsyslog

The command above will start up the rsyslog daemon in `syslog` container which will result in creating the socket.

To share this socket to another container, you need to volume mount just the socket as `/dev/log`.

    docker run -it --rm -v /tmp/rsyslog/imuxsock:/dev/log busybox

Now, if you log some messages from the `busybox` container, you will be able to see these logged into `/var/log/messages` on the `syslog` container.

    / # logger "Test message"
    / # exit

In order to inspect the messages, you can spin up another container in another terminal; you can see the message.
    
    / # docker run -it --rm --volumes-from=syslog busybox tail /var/log/messages
    
    Mar  3 19:21:04 eb40accfee71 root: Test message

# What next?

Configure rsyslog to forward messages to another server / service. The image comes with elasticsearch module which can be used to formward messages to ELK stack.

**IMPORTANT:** For heavy loads or production deployments, you must configure it to not log to disk (`/var/log/messages`).

# Caveats

 - You will loose the hostname information of the logging application. The hostname that appears in the log will always be that of the `syslog` container, which is a meaningles hash created by docker (the container ID). You may consider [rsyslog property replacer](http://www.rsyslog.com/doc/v8-stable/configuration/property_replacer.html) to help you with this.
 - The `redmatter/rsyslog` is by default configured to log to `/var/log/messages`. This can get out of hand if you use it as is in heavy load production environments, as there is no `logrotate` functionality. Have a look at [`forward.conf.example`](forward.conf.example) in order to configure rsyslog to forward all messages to another host. You may also use [`elasticsearch` module](http://www.rsyslog.com/doc/v8-stable/configuration/modules/omelasticsearch.html) to forward messages to ELK stack (though it will make logstash redundant).

# Bedtime reading

 - https://jpetazzo.github.io/2014/08/24/syslog-docker/
 - https://blog.logentries.com/2014/03/how-to-run-rsyslog-in-a-docker-container-for-logging/

