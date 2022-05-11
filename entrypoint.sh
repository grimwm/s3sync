#!/usr/bin/env bash
# Utility to synchronize files between a directory and s3-compatible provider.

# Setup s3 credentials.
mkdir "${HOME}/.aws"
echo '[default]' > "${HOME}/.aws/config"
cat >"${HOME}/.aws/credentials" <<EOF
[default]
aws_access_key_id = ${S3_ACCESS_KEY_ID}
aws_secret_access_key = ${S3_SECRET_ACCESS_KEY}
EOF
chmod 0600 "${HOME}/.aws/credentials"

exec "$@"
