#!/usr/bin/env bash
#  PURPOSE: Lock build account: devops. Run this script last.
# -----------------------------------------------------------------------------
#  PREREQS: a) list of users and their public keys
#           b)
#           c)
# -----------------------------------------------------------------------------
#  EXECUTE: add to the packer shell provisioner
# -----------------------------------------------------------------------------
#     TODO: 1)
#           2)
#           3)
# -----------------------------------------------------------------------------
#   AUTHOR: Todd E Thomas
# -----------------------------------------------------------------------------
#  CREATED: 2018/09/10
# -----------------------------------------------------------------------------
set -x

###----------------------------------------------------------------------------
### VARIABLES
###----------------------------------------------------------------------------
# ENV Stuff


###----------------------------------------------------------------------------
### FUNCTIONS
###----------------------------------------------------------------------------
function pMsg() {
    theMesssage="$1"
    printf '%s\n' "==> $theMesssage"
}

function listUsers() {
    awk -F '[:]' '{{if ($3 >= 1000)print $3" "$6}}' /etc/passwd
}

###----------------------------------------------------------------------------
### MAIN PROGRAM
###----------------------------------------------------------------------------
### Disable devops account
###---
# Lock the account
usermod --lock devops
# Expire the account
chage   -E0    devops
# Make sure this user can't get a shell, even with ssh logins
usermod --shell /sbin/nologin devops
# Display the final account status
passwd  --status devops


###---
### List all users
###---
listUsers


###---
### fin~
###---
exit 0
