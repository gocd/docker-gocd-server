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

FROM alpine:3.6

MAINTAINER GoCD <go-cd-dev@googlegroups.com>

LABEL gocd.version="17.10.0" \
  description="GoCD server based on alpine linux" \
  maintainer="GoCD <go-cd-dev@googlegroups.com>" \
  gocd.full.version="17.10.0-5380" \
  gocd.git.sha="05598d88fd4dabdde1184faa4fbffc5f9406d0dc"

# the ports that go server runs on
EXPOSE 8153 8154

# force encoding
ENV LANG=en_US.utf8

ARG UID=1000
ARG GID=1000

RUN \
# add our user and group first to make sure their IDs get assigned consistently,
# regardless of whatever dependencies get added
  addgroup -g ${GID} go && \
  adduser -D -u ${UID} -G go go && \
# install dependencies and other helpful CLI tools
  apk --no-cache upgrade && \
  apk add --no-cache openjdk8-jre-base git mercurial subversion tini openssh-client bash su-exec curl && \
# download the zip file
  curl --fail --location --silent --show-error "https://download.gocd.org/binaries/17.10.0-5380/generic/go-server-17.10.0-5380.zip" > /tmp/go-server.zip && \
# unzip the zip file into /go-server, after stripping the first path prefix
  unzip /tmp/go-server.zip -d / && \
  rm /tmp/go-server.zip && \
  mv go-server-17.10.0 /go-server && \
# ensure that logs are printed to console output
  sed -i -e 's/\(log4j.rootLogger.*\)/\1, stdout/g' /go-server/config/log4j.properties && \
  echo "" >> /go-server/config/log4j.properties && \
  echo "" >> /go-server/config/log4j.properties && \
  echo "# Log to stdout" >> /go-server/config/log4j.properties && \
  echo "log4j.appender.stdout=org.apache.log4j.ConsoleAppender" >> /go-server/config/log4j.properties && \
  echo "log4j.appender.stdout.layout=org.apache.log4j.PatternLayout" >> /go-server/config/log4j.properties && \
  echo "log4j.appender.stdout.layout.conversionPattern=%d{ISO8601} %5p [%t] %c{1}:%L - %m%n" >> /go-server/config/log4j.properties

ADD docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
