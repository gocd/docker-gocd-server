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

LABEL gocd.version="17.8.0" \
  description="GoCD server based on alpine linux" \
  maintainer="GoCD <go-cd-dev@googlegroups.com>" \
  gocd.full.version="17.8.0-5277" \
  gocd.git.sha="32ff863cce99f97b76abb1b88469a793e3b1adc5"

# allow mounting the go server config and data
VOLUME /godata

# the ports that go server runs on
EXPOSE 8153 8154

# force encoding
ENV LANG=en_US.utf8

# allow alternative go uid
ARG UID=1000

RUN \
# add our user and group first to make sure their IDs get assigned consistently,
# regardless of whatever dependencies get added
  addgroup -g ${UID} go && \
  adduser -D -u ${UID} -G go go && \
# install dependencies and other helpful CLI tools
  apk --no-cache upgrade && \
  apk add --no-cache openjdk8-jre-base git mercurial subversion tini openssh-client bash su-exec curl && \
# download the zip file
  curl --fail --location --silent --show-error "https://download.gocd.org/binaries/17.8.0-5277/generic/go-server-17.8.0-5277.zip" > /tmp/go-server.zip && \
# unzip the zip file into /go-server, after stripping the first path prefix
  unzip /tmp/go-server.zip -d / && \
  rm /tmp/go-server.zip && \
  mv go-server-17.8.0 /go-server

ADD docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
