# Docker GoCD Server 17.4.0

## Bug Fixes

* [d49ffa4](https://github.com/gocd/docker-gocd-server/commit/d49ffa4) Remove `/home/go` from the volume instruction. This makes the `/home/go` directory writable by the `go` user.
