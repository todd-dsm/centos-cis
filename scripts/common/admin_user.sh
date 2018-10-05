#!/usr/bin/env bash
set -eux

# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-'/home/devops'}";
sshDir="$HOME_DIR/.ssh"
authKeysFile="$sshDir/authorized_keys"
pubkey_url='https://git.mascorp.com/thomast23/my-stuff/raw/master/thomast23.pub'

mkdir -p "$sshDir"
if command -v wget >/dev/null 2>&1; then
    wget --no-check-certificate "$pubkey_url" -O "$authKeysFile"
elif command -v curl >/dev/null 2>&1; then
    curl --insecure --location "$pubkey_url" > "$authKeysFile"
elif command -v fetch >/dev/null 2>&1; then
    fetch -am -o "$authKeysFile" "$pubkey_url";
else
    echo "Cannot download vagrant public key";
    exit 1;
fi
chown -R devops "$sshDir"
chmod -R go-rwsx "$sshDir"
