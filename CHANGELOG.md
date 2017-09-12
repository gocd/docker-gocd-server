# Docker GoCD Server 17.10.0

* [90d8bc8](https://github.com/gocd/docker-gocd-server/commit/90d8bc8d9abef7198351fb4a7c35f88bde386ebe) Allow users to specify `uid` and `gid` as build args while building a docker image.
* [8c3b9f9](https://github.com/gocd/docker-gocd-server/commit/8c3b9f90a81a296cc95f2f34e13c6eea39b172d0) Remove the volume instruction for godata directory. Fix for https://github.com/gocd/docker-gocd-server/issues/25

# Docker GoCD Server 17.9.0

* log server output and logs to `STDOUT` in addition to writing logs to log files, so you can now watch all server logs using `docker logs`.

# Docker GoCD Server 17.8.0

* [e4fcb35](https://github.com/gocd/docker-gocd-server/commit/e4fcb355848877689fdf4d193d554573056c85f0) Reduce the docker GoCD server image's size by removing the downloaded binary after its extracted.
* [85b0c76](https://github.com/gocd/docker-gocd-server/commit/85b0c76321cc2fffbcaae913b757f6cf72782cdf) Fail on error when the download of the server zip fails.
* [7928995](https://github.com/gocd/docker-gocd-server/commit/792899553210ec006131e562c3ba94f3d53da6d6) Use `apk --no-cache` to prevent caching

# Docker GoCD Server 17.7.0

No changes

# Docker GoCD Server 17.6.0

No changes

# Docker GoCD Server 17.5.0

No changes

# Docker GoCD Server 17.4.0

## Bug Fixes

* [d49ffa4](https://github.com/gocd/docker-gocd-server/commit/d49ffa4) Remove `/home/go` from the volume instruction. This makes the `/home/go` directory writable by the `go` user.
