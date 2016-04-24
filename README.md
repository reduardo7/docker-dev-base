# docker-dev-base
Docker Development Base Script

# Pre-Init

1. Install **Docker**.

# Init

1. `./dockdev install`: Install required software and common configurations.
2. `./dockdev build`: Build unique image.
3. `./dockdev run`: Run first init, import projects, configurations...

Next times, only exec `./dockdev run`.

# Workflow

1. Go to project root directory: `cd path/to/docker-dev-base`
2. Install required software and configuration: `bash dockdev install`
3. Build image: `bash dockdev build`
4. Run:
    1. Run **default** container: `bash dockdev run`
    2. Run **another** container: `bash dockdev run CONTAINER_NAME`
5. Open new command line: `bash dockdev new-console`

# Doc

## Utils

See help:

```
#!shell
~/utils.sh help
```

## Mails

### Docker Path

`/var/mail`

### Host Path

`/tmp/fakemail`

# Logs

## Mail (FakeSMTP)

`/var/mail/mail.log`

## Apache

`/var/log/apache2/*.log`

# Access & Password

## System user password

The `username`.

## MySQL

* User: `root`
* Password: - no password -
* Internal Port: `3306` (inside Docker, for internal software and service, such as Apache)
* Public Port: `3307` (outside Docker, for remote connection, IDE, etc)

## phpMyAdmin

* URL: http://localhost/phpmyadmin
* User: `root`
* Password: - no password -
