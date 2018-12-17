#!/bin/sh -eux

sshdConfig="/etc/ssh/sshd_config"

# ensure that there is a trailing newline before attempting to concatenate
sed -i -e '$a\' "$sshdConfig"

USEDNS="UseDNS no"
if grep -q -E "^[[:space:]]*UseDNS" "$sshdConfig"; then
    sed -i "s/^\s*UseDNS.*/${USEDNS}/" "$sshdConfig"
else
    echo "$USEDNS" >>"$sshdConfig"
fi

GSSAPI="GSSAPIAuthentication no"
if grep -q -E "^[[:space:]]*GSSAPIAuthentication" "$sshdConfig"; then
    sed -i "s/^\s*GSSAPIAuthentication.*/${GSSAPI}/" "$sshdConfig"
else
    echo "$GSSAPI" >>"$sshdConfig"
fi


###---
### Disable the banner.
### This isn't Battleship - we don't have to confirm a direct hit.
###---
# uncomment 'Banner none'
sed -i '/Banner none/ s/^#//g' "$sshdConfig"

# remove the lines enabling the Banner
sed -i '/issue/d' "$sshdConfig"

# Display the Banner config
grep 'Banner' "$sshdConfig"
