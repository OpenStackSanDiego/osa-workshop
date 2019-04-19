#!/bin/sh

#
# create the bridges required for OSA
# this file was created by Terraform
#

# make this script re-entrant
/sbin/ip link show br-mgmt 2> /dev/null
ret=$?
echo "Does the link already exist?" $ret
if [ $ret == 0 ]; then
  # if the br-mgmt exists then leave so it doesn't get set back up again
  exit $ret
fi

echo MGMT_IP ${MGMT_IP}
echo MGMT_SUBNET ${MGMT_SUBNET}
echo VXLAN_IP ${VXLAN_IP}
echo VXLAN_SUBNET ${VXLAN_SUBNET}

brctl addbr br-mgmt
ip addr add ${MGMT_IP}/28 dev br-mgmt

brctl addbr br-vxlan
ip addr add ${VXLAN_IP}/28 dev br-mgmt
