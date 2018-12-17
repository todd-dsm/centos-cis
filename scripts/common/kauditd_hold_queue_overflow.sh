#!/usr/bin/env bash
# shellcheck disable=SC1091
set -x
source /etc/os-release

sysGrubConf='/etc/default/grub'

echo "/etc/default/grub: before"
grep GRUB_CMDLINE_LINUX "$sysGrubConf"

sed -i '/GRUB_CMDLINE_LINUX/ s/"$/\ audit_backlog_limit=8192"/' /etc/default/grub

echo "/etc/default/grub: after"
grep GRUB_CMDLINE_LINUX "$sysGrubConf"

# rebuild grub2 menu
grub2-mkconfig -o /boot/grub2/grub.cfg

# and again for UEFI
grub2-mkconfig -o "/boot/efi/EFI/$ID/grub.cfg"

