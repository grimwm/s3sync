# s3sync

This is the code and Docker container for synchronizing files in a directory
with an s3-compatible cloud storage provider, such as:

* AWS S3
* Azure Blob Storage
* DigitalOcean Spaces
* Google Cloud Storage
* Linode Object Storage
* Vultr Object Storage
* And so on...

This project is intended to be used as a Docker container, but nothing
precludes use of the application directly on a host machine, assuming the
pre-requisites are met. However, since all development can be done by building
and re-building containers, use of this project outside Docker is not covered.

## Usage

### Environment Variables

This project is controlled via environment variables.

Required environment variables:

* `S3_ACCESS_KEY_ID`
* `S3_SECRET_ACCESS_KEY`
* `S3_BUCKET`

Optional environment variables:

* `S3_ENDPOINT`: defaults to `''` and is mostly used with s3-compatible storage
   outside of AWS.
* `S3_ACL`: defaults to `private` but can be any of
  `{private, public-read, public-read-write}` or anything else listed in
  [Canned ACLs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl).
* `SYNC_DIRECTORY`: defaults to `/mnt` but may be set to anything.

### Docker

The general intent is to use this project via Docker or Kubernetes. Please
find the latest tagged image at
[Docker Hub](https://hub.docker.com/repository/docker/grimwm/s3sync) and
follow standard Docker or Kubernetes procedures for using it.

When running the container, ensure that a volume is shared to the container's
at the location matching `SYNC_DIRECTORY`. This directory will first be synced
with the remote S3 location, and then incremental updates from the local
directory to the remote directory will occur.

Please note at this time that only updates to files will be pushed up.
Deleting a file locally will not remove it in S3.
