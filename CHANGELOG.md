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
