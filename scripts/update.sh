#!/bin/sh -eux

yum -y update

# system tools
yum install -y open-vm-tools lsof strace

# diagnostic tools; comment this line before prod
yum install -y vim-common vim-enhanced tree git bind-utils

reboot
sleep 60
