#!/usr/bin/env bash
# shellcheck disable=SC1091
# PURPOSE: Pack a generic os to a location
#    TODO: hypervisor type can be changed in the buildOS function.
set -x

# Exit if some required values are not set
"${VAGRANT_BOXES:?VAGRANT_BOXES variable is not set or empty}"

# vars
source ./env.sh
packerDefinition="$1"
logFile="/tmp/packer_$(date +%F_%T_%Z)_${packerDefinition%%.*}.out"
myBox='centos-7.5-cis'
boxName="centos-cis"
boxFile="${VAGRANT_BOXES}/centos/${myBox}.virtualbox.box"

# Array of packer sub-commands that we'll use to build
declare -a pSubCMDs=('validate' 'inspect' 'build')


# functs
function pMsg() {
    theMesssage="$1"
    printf '%s\n' "==> $theMesssage"
}
function buildOS() {
    pMsg "Building!"
    packer build -color=false -force -only=virtualbox-iso \
        "$packerDefinition" 2>&1 | tee "$logFile"
}

# did we get input?
if [[ -z "$packerDefinition" ]]; then
    pMsg "Bro, we need input or we can't run; I'm out."
    exit 1
fi

# remove old artifacts if they exist
if [[ -f "$boxFile" ]]; then
    vboxmanage unregistervm centos-7.5-cis --delete
    rm -rf "$boxFile"
fi


for subCMD in "${pSubCMDs[@]}"; do
    printf '%s\n' "${subCMD^}ing..."
    if [[ "$subCMD" == 'build' ]]; then
        buildOS
        break
    else
        if ! packer "$subCMD" "$packerDefinition"; then
            pMsg "Something flaked, I'm out."
            exit 1
        fi
    fi
done


###----------------------------------------------------------------------------
### Import Vagrant box
###----------------------------------------------------------------------------
# Add it to the local Vagrant registry
echo -e "Adding CentOS 7 / CIS to the local registry..."
sleep 5
vagrant box add --force "$boxName" "$boxFile"
echo ""

# display boxes
vagrant box list
echo ""


###----------------------------------------------------------------------------
### Unnecessary; Nutanix accepts a VMDK file
### Convert the image from VMDK -> QCOW2 / Brittle from here down
###----------------------------------------------------------------------------
echo -e "The box and vmdk is here:"
tree "$HOME/vms/vagrant/boxes/${boxName}/0/virtualbox"

echo -e "When new images are ready, run:"
cp ~/vms/vagrant/boxes/${boxName}/0/virtualbox/centos-7.5-cis-disk001.vmdk \
   ~/Downloads/vms/centos-7.5-cis-disk001.vmdk

echo -e "Then upload to Nutanix from there."

