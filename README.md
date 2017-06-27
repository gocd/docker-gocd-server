# GoCD Server Docker image

An Alpine Linux based docker image for [GoCD server](https://www.gocd.io).

# Docker Image
*You could either download the latest built image from docker hub or build one
locally with the zip file from GoCD Download webpage.*

## 1.1 Download the latest Image
```bash
docker pull gocd/gocd-server:v17.3.0
```

## 1.2 Build One Locally
Build one with version `17.3.0`; zip file is from GoCD [`download`][0] webpage.
```bash
GOCD_VERSION=17.3.0 \
GOCD_SERVER_DOWNLOAD_URL=https://download.gocd.io/binaries/17.3.0-4704/generic/go-server-17.3.0-4704.zip \
rake build_image
```

# Usage
Start the container with this:

```bash
docker run -d -p8153:8153 -p8154:8154 gocd/gocd-server:v17.3.0
```

This will expose container ports 8153(http) and 8154(https) onto your server.
You can now open `http://localhost:8153` and `https://localhost:8154`

# Available configuration options

## Mounting volumes

The GoCD server will store all configuration, pipeline history database,
artifacts, plugins, and logs into `/godata`. If you'd like to provide secure
credentials like SSH private keys among other things, you can mount `/home/go`

```bash
docker run -v /path/to/godata:/godata -v /path/to/home-dir:/home/go gocd/gocd-server
```

> **Note:** Ensure that `/path/to/home-dir` and `/path/to/godata` is accessible by the `go` user in container (`go` user - uid 1000).

## Installing plugins

All plugins can be installed under `/godata`.

```
mkdir -p /path/to/godata/plugins/external
curl --location --fail https://example.com/plugin.jar > /path/to/godata/plugins/external/plugin.jar
chown -R 1000 /path/to/godata/plugins
```

## Installing addons

All addons can be installed under `/godata`.

```
mkdir -p /path/to/godata/addons
curl --location --fail https://example.com/addon.jar > /path/to/godata/addons/plugin.jar
chown -R 1000 /path/to/godata/addons
```

## Tweaking JVM options (memory, heap etc)

JVM options can be tweaked using the environment variable `GO_SERVER_SYSTEM_PROPERTIES`.

```bash
docker run -e GO_SERVER_SYSTEM_PROPERTIES="-Xmx4096mb -Dfoo=bar" gocd/gocd-server
```

# Under the hood

The GoCD server runs as the `go` user, the location of the various directories is:

| Directory           | Description                                                                      |
|---------------------|----------------------------------------------------------------------------------|
| `/godata/addons`    | the directory where GoCD addons are stored                                       |
| `/godata/artifacts` | the directory where GoCD artifacts are stored                                    |
| `/godata/config`    | the directory where the GoCD configuration is store                              |
| `/godata/db`        | the directory where the GoCD database and configuration change history is stored |
| `/godata/logs`      | the directory where GoCD logs will be written out to                             |
| `/godata/plugins`   | the directory containing GoCD plugins                                            |
| `/home/go`          | the home directory for the GoCD server                                           |

# Determine Server IP and Ports on Host

Once the GoCD server is up, we should be able to determine its ip address and the ports mapped onto the host by doing the following:
The IP address and ports of the GoCD server in a docker container are important to know as they will be used by the GoCD agents to connect to it.
If you have started the container with
```bash
docker run --name server -it -p8153:8153 -p8154:8154 gocd/gocd-server:v17.3.0
```

Then, the below commands will determine to GoCD server IP, server port and ssl port
```bash
docker inspect --format='{{(index (index .NetworkSettings.IPAddress))}}' server
docker inspect --format='{{(index (index .NetworkSettings.Ports "8153/tcp") 0).HostPort}}' server
docker inspect --format='{{(index (index .NetworkSettings.Ports "8154/tcp") 0).HostPort}}' server
```

# Troubleshooting

## The GoCD server does not come up

- Check if the docker container is running `docker ps -a`
- Check the STDOUT to see if there is any output that indicates failures `docker logs CONTAINER_ID`
- Check the server logs `docker exec -it CONTAINER_ID tail -f /godata/logs/go-server.log` (or check the log file in the volume mount, if you're using one)


# Bugs with Docker Server Image 17.3.0

* Anyone using our docker image as the base image for your customized image, and writing to `/home/go` as part of your Dockerfile, these changes in `/home/go` don't persist while you start the container with your custom image.
 A fix has been applied [here](https://github.com/gocd/docker-gocd-server/commit/d49ffa4) and will be available for subsequent releases of the docker images.
 
# License

```plain
Copyright 2017 ThoughtWorks, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[0]: https://www.gocd.io/download/
