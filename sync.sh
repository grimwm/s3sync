#!/usr/bin/env bash
# Utility to synchronize files between a directory and s3-compatible provider.

SYNC_DIRECTORY=${SYNC_DIRECTORY:-/mnt}
S3_ACL=${S3_ACL:-private}

# Configure aws cmd.
AWS="aws --quiet"
[[ "${S3_ENDPOINT}" != "" ]] && AWS="${AWS} --endpoint-url=${S3_ENDPOINT}"

# Sync between s3 and the mounted volume.
${AWS} s3 sync "${S3_BUCKET}" "${SYNC_DIRECTORY}"
${AWS} s3 sync "${SYNC_DIRECTORY}" "${S3_BUCKET}" --acl "${S3_ACL}"

# Watch mounted volume for new files and sync them to s3.
cd "${SYNC_DIRECTORY}"
while line=$(inotifywait -q -r -e close_write "${SYNC_DIRECTORY}") ; do
  directory=$(echo ${line} | awk '{ print $1; }')
  filename=$(echo ${line} | awk '{ print $3; }')
  path=$(realpath --relative-to="${SYNC_DIRECTORY}" "${directory}/${filename}")

  echo "Copying ${path} to ${S3_BUCKET}"
  ${AWS} s3 cp "${path}" "${S3_BUCKET}" --acl "${S3_ACL}"
done
