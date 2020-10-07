This example application is there just so that the docker compose file is more meaningful.

Once the (docker-)composed services are up, you can access the application from a browser by using the below URL, where you can replace `<name>` with a word or name of your choice.

    http://<DockerHost-IP>:8088/index.php/hello/<name>

The app will log messages to syslog, via monolog.
