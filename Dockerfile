# Copyright 2017 ThoughtWorks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM alpine:latest

MAINTAINER GoCD <go-cd-dev@googlegroups.com>

ARG GOCD_VERSION="17.3.0"
ARG DOWNLOAD_URL="https://download.gocd.io/binaries/17.3.0-4704/generic/go-server-17.3.0-4704.zip"
ARG GID=1000
ARG UID=1000

LABEL gocd.version=${GOCD_VERSION} \
  description="GoCD server based on alpine linux" \
  maintainer="GoCD <go-cd-dev@googlegroups.com>"

ADD ${DOWNLOAD_URL} /tmp/go-server.zip

# allow mounting ssh keys, dotfiles, and the go server config and data
VOLUME /home/go /godata

# the ports that go server runs on
EXPOSE 8153 8154

# force encoding
ENV LANG=en_US.utf8

RUN \
# add our user and group first to make sure their IDs get assigned consistently,
# regardless of whatever dependencies get added
  addgroup -g ${GID} go && \
  adduser -D -u ${UID} -G go -s /bin/sh go && \
# install dependencies and other helpful CLI tools
  apk --update-cache upgrade && \
  apk add --update-cache openjdk8-jre-base git mercurial subversion tini openssh-client bash su-exec && \
# unzip the zip file into /go-server, after stripping the first path prefix
  unzip /tmp/go-server.zip -d / && \
  rm /tmp/go-server.zip && \
  mv go-server-${GOCD_VERSION} /go-server

ADD docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
