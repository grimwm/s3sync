#!/usr/bin/env bash
# Utility to synchronize files between a directory and s3-compatible provider.

SYNC_DIRECTORY=${SYNC_DIRECTORY:-/mnt}

# Setup s3 credentials.
mkdir "${HOME}/.aws"
echo '[default]' > "${HOME}/.aws/config"
cat >"${HOME}/.aws/credentials" <<EOF
[default]
aws_access_key_id = ${S3_ACCESS_KEY_ID}
aws_secret_access_key = ${S3_SECRET_ACCESS_KEY}
EOF
chmod 0600 "${HOME}/.aws/credentials"

# Configure aws cmd.
AWS=aws
[[ "${S3_ENDPOINT}" != "" ]] && AWS="${AWS} --endpoint-url=${S3_ENDPOINT}"

# Sync between s3 and the mounted volume.
${AWS} s3 sync "${S3_BUCKET}" "${SYNC_DIRECTORY}"
${AWS} s3 sync "${SYNC_DIRECTORY}" "${S3_BUCKET}"

# Watch mounted volume for new files and sync them to s3.
cd "${SYNC_DIRECTORY}"
while filename=$(inotifywait -q -e close_write "${SYNC_DIRECTORY}" | sed 's/.*CLOSE.* //g;') ; do
  echo "Copying ${filename} to ${S3_BUCKET}"
  # TODO make uploaded files public (configurable)
  ${AWS} --quiet s3 cp "${filename}" "${S3_BUCKET}"
done
