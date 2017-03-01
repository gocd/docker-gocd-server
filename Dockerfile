FROM alpine:latest
MAINTAINER GoCD <go-cd-dev@googlegroups.com>

ARG GO_WORKING_DIR="/go-working-dir"
ARG VOLUME_DIR="/godata"

ARG GOCD_VERSION="17.2.0"
ARG DOWNLOAD_URL="https://download.gocd.io/binaries/17.2.0-4587/generic/go-server-17.2.0-4587.zip"

ADD ${DOWNLOAD_URL} /tmp/go-server.zip

RUN apk add --update-cache openjdk8-jre-base git mercurial subversion tini openssh-client bash && \
# unzip the zip file into /go-server, after stripping the first path prefix
  unzip /tmp/go-server.zip -d / && \
  mv go-server-${GOCD_VERSION} /go-server && \
# Exposing volumes in a simple manner, and setup links behind-the-scenes
# to match GoCD's directory structure
  mkdir -p ${GO_WORKING_DIR} && \
  mkdir -p ${VOLUME_DIR}/artifacts && \
  ln -sf ${VOLUME_DIR}/artifacts ${GO_WORKING_DIR}/artifacts && \
  mkdir -p ${VOLUME_DIR}/config && \
  ln -sf ${VOLUME_DIR}/config ${GO_WORKING_DIR}/config && \
  mkdir -p ${VOLUME_DIR}/db && \
  ln -sf ${VOLUME_DIR}/db ${GO_WORKING_DIR}/db && \
  mkdir -p ${VOLUME_DIR}/logs && \
  ln -sf ${VOLUME_DIR}/logs ${GO_WORKING_DIR}/logs && \
  mkdir -p ${VOLUME_DIR}/plugins && \
  ln -sf ${VOLUME_DIR}/plugins ${GO_WORKING_DIR}/plugins && \
  mkdir -p ${VOLUME_DIR}/addons && \
  ln -sf ${VOLUME_DIR}/addons ${GO_WORKING_DIR}/addons && \
  adduser -D go && \
  chown -R go:go ${VOLUME_DIR} ${GO_WORKING_DIR}

# allow mounting ssh keys, dotfiles, and the go server config and data
VOLUME ["/home/go", "${VOLUME_DIR}"]

# the ports that go server runs on
EXPOSE 8153 8154

USER go
ENTRYPOINT ["/sbin/tini", "--"]
WORKDIR ${GO_WORKING_DIR}
ENV GO_CONFIG_DIR=${GO_WORKING_DIR}/config
ENV SERVER_WORK_DIR=${GO_WORKING_DIR}
ENV STDOUT_LOG_FILE=${GO_WORKING_DIR}/logs
CMD ["/go-server/server.sh"]
