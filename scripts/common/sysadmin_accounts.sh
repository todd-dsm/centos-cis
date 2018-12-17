#!/usr/bin/env bash
#  PURPOSE: Add users to a packer-built OS.
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
#pubkey_url='https://git.mascorp.com/thomast23/my-stuff/raw/master/thomast23.pub'
userBashrc='/tmp/configs/bashrc'
keysDir='/tmp/keys'
sysSudoersDir='/etc/sudoers.d'
declare -a sysAdmins=(
    'thomast23'
    'vanderhoofm'
    'hayashid'
    )

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
### Display users on the system with UIDs >= 1000
###---
pMsg "Displaying all users on the system with UIDs > 1000..."

if [[ -z "$(listUsers)" ]]; then
    pMsg "There are no users configured on the system."
else
    pMsg "These are the existing users:"
    listUsers
fi


###---
### Process users and add them to the system
### REQUIRED: the file upload provisioner must be run before this step
###---
for admin in "${sysAdmins[@]}"; do
    # Construct Variables
    adminHome="/home/$admin"
    sshDir="$adminHome/.ssh"
    authKeysFile="$sshDir/authorized_keys"
    # Process Users
    pMsg "Adding $admin to the system..."
    adduser --home-dir "$adminHome" "$admin"
    usermod -aG wheel "$admin"
    mkdir -p "$sshDir"
    # Add user's public keys
    cp --force "$keysDir/$admin.pub" "$authKeysFile"
    chmod 600 "$authKeysFile"
    # Add conveniences
    cp --force "$userBashrc"  "$adminHome/.bashrc"
    # Add user profiles to /etc/sudoers.d directory
    pMsg "Granting sudo to $admin..."
    echo "$admin ALL=(ALL) NOPASSWD:ALL" | sudo tee "$sysSudoersDir/$admin"
    chmod 600 "$sysSudoersDir/$admin"
    ### Setting perms
    # ensure user owns its own files
    find "$adminHome" -exec chown "$admin:$admin" {} \;
    # adhere to target umask for a CIS system
    find "$adminHome" -type d -exec chmod 0750 {} \;
    find "$adminHome" -type f -exec chmod 0640 {} \;
    # apply special permissions for the ssh mechanics
    chmod 0700 "$sshDir"
    chmod 0600 "$authKeysFile"
done


###---
### Display users on the system with UIDs >= 1000
###---
pMsg "AGAIN: Displaying all users on the system with UIDs > 1000..."
if [[ -z "$(listUsers)" ]]; then
    pMsg "There are no users configured on the system."
else
    pMsg "These are the existing users:"
    listUsers
fi


###---
### REQ
###---


###---
### fin~
###---
exit 0
