# The Packer artifacts (and Vagrant if necessary) can be stored anywhere. That
# is controlled by the variables below. These variables *should* be adjusted
# before being left in the pipeline for longer periods.
#VAGRANT_BOXES
PACKER_BUILD_DIR="/tmp/os-builds"
#export PACKER_HOME="$HOME/vms/packer"
#export PACKER_CONFIG="$PACKER_HOME"
#export PACKER_CACHE_DIR="$PACKER_HOME/iso-cache"
export PACKER_LOG='yes'
export PACKER_LOG_PATH='/tmp/packer.log'
export PACKER_NO_COLOR='yes'
