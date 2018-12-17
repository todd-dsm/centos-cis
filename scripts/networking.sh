#!/bin/sh -eux

case "$PACKER_BUILDER_TYPE" in

virtualbox-iso|virtualbox-ovf)
    major_version="$(sed 's/^.\+ release \([.0-9]\+\).*/\1/' /etc/redhat-release | awk -F. '{print $1}')";

    if [ "$major_version" -ge 6 ]; then
        # Fix slow DNS:
        # Add 'single-request-reopen' so it is included when /etc/resolv.conf is
        # generated
        # https://access.redhat.com/site/solutions/58625 (subscription required)
        echo 'RES_OPTIONS="single-request-reopen"' >>/etc/sysconfig/network;
        service network restart;
        echo 'Slow DNS fix applied (single-request-reopen)';
    fi
    ;;

esac

# ----------------------------------------------------------------------------#
#                            PANASONIC CONFIGS                                #
# ----------------------------------------------------------------------------#
# Assign NIC a predictable name in NetworkManager
# ---
conName='wired'
netConfigFile='/etc/sysconfig/network-scripts/ifcfg-enp0s3'

echo "Network Info"
ip a

echo "NetworkManager Info"
nmcli con show

echo "Renaming connection name..."
sed -i "/parse-kickstart$/a\NAME=\"$conName\"" "$netConfigFile"

systemctl restart NetworkManager


echo "NetworkManager Info, again:"
nmcli con show

# ----------------------------------------------------------------------------#
# ANetworkManager: assign DNS search domains and nameserver
# ---

nmcli con show "$conName" | grep ipv4.dns

nmcli con mod  "$conName" ipv4.dns-search 'consul noc.mascorp.com mascorp.com'
nmcli con mod  "$conName" ipv4.dns '192.168.246.120,192.168.252.230,192.168.248.220'
systemctl restart NetworkManager

nmcli con show "$conName" | grep ipv4.dns
cat /etc/resolv.conf



