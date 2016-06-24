# DockDev: Docker Development Environment - Base
Docker Development Base Script

# Pre-Init

1. Install **docker**.
2. Set **SSH Key** for **Bitbucket** and **GitHub** accounts. **WARNING**: **No** use **passphrase** for your **SSH Key**!

# Init/Setup

1. Go to project root directory: `cd path/to/docker-dev-base`
2. `./dockdev install`: Install required software and common configurations.
3. `./dockdev build`: Build unique image.
4. `./dockdev run`: Run first init, import projects, configurations...

# Workflow

1. Go to: `cd path/to/avantrip-autos-dockdev`
2. Start: `./dockdev run` o `./dockdev start`

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

# Users & Password

## System user password

The `username`.

## MySQL

* User: `root`
* Password: - no password -
* Port: `3306`

## phpMyAdmin

* URL: http://localhost/phpmyadmin
* User: `root`
* Password: - no password -
