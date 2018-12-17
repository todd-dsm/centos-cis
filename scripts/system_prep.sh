#!/usr/bin/env bash
#  PURPOSE: A mish-mosh of build-stoppers.
# -----------------------------------------------------------------------------
#  PREREQS: a)
#           b)
#           c)
# -----------------------------------------------------------------------------
#  EXECUTE:
# -----------------------------------------------------------------------------
#     TODO: 1)
#           2)
#           3)
# -----------------------------------------------------------------------------
#   AUTHOR: Todd E Thomas
# -----------------------------------------------------------------------------
#  CREATED: 2018/12/17
# -----------------------------------------------------------------------------
set -x


###----------------------------------------------------------------------------
### VARIABLES
###----------------------------------------------------------------------------
# ENV Stuff
# Data Files


###----------------------------------------------------------------------------
### FUNCTIONS
###----------------------------------------------------------------------------
function pMsg() {
    theMessage="$1"
    printf '%s\n' "$theMessage"
}

###----------------------------------------------------------------------------
### MAIN PROGRAM
###----------------------------------------------------------------------------
### ADD: 'account    required     pam_unix.so' to /etc/pam.d/sudo
### After CentOS 7.x this message started appearing during Packer builds:
###     virtualbox-iso: sudo: Account expired or PAM config lacks an "account"
###     section for sudo, contact your system administrator.
### If it stops the complaint, and subsequent job-stop, then fine.
###---
pMsg "Fixing: Account expired or PAM config lacks an 'account' section for sudo"
pamSudo='/etc/pam.d/sudo'
grep '^account' "$pamSudo"
sed -i '/^account/a\account    required     pam_unix.so' "$pamSudo"
grep '^account' "$pamSudo"



###---
### REQ
###---


###---
### REQ
###---


###---
### REQ
###---


###---
### REQ
###---


###---
### REQ
###---


###---
### REQ
###---


###---
### REQ
###---


###---
### REQ
###---


###---
### REQ
###---


###---
### REQ
###---


###---
### fin~
###---
exit 0
