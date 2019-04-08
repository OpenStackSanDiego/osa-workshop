#!/bin/sh

#
# create the br-mgmt required for OSA
# this file was created by Terraform
#

# make this script re-entrant
/sbin/ip link show br-mgmt > /dev/null
ret=$?
echo $ret
if [ $ret == 0 ]; then
  # if the br-mgmt exists then leave so it doesn't get set back up again
  exit $ret
fi

PUBLIC_GATEWAY=`ip route list | egrep "^default" | cut -d' ' -f 3`
PRIVATE_GATEWAY=`ip route list | egrep "^10.0.0.0/8" | cut -d' ' -f 3`
PUBLIC_IP=`hostname -I | cut -d' ' -f 1`
PRIVATE_IP=`hostname -I | cut -d' ' -f 2`
PUBLIC_SUBNET=`ip -4 -o addr show dev bond0 | grep $PUBLIC_IP | cut -d ' ' -f 7`

echo PUBLIC_GATEWAY $PUBLIC_GATEWAY
echo PRIVATE_GATEWAY $PRIVATE_GATEWAY
echo PUBLIC_IP $PUBLIC_IP
echo PRIVATE_IP $PRIVATE_IP
echo PUBLIC_SUBNET $PUBLIC_SUBNET

# Container/Host management br-mgmt

# moves networking from the bond0 interface to the br-mgmt interface
# be careful, this may disconnect your SSH connection - run as a script not one line at a time

ip addr flush dev bond0

brctl addbr br-mgmt
brctl addif br-mgmt bond0

ip addr add $PUBLIC_SUBNET dev br-mgmt
ip addr add $PRIVATE_IP/31 dev br-mgmt


# link needs to be up before so link routes are live before adding next hop routes
ip link set dev br-mgmt up

ip route add default via $PUBLIC_GATEWAY dev br-mgmt
ip route add 10.0.0.0/8 via $PRIVATE_GATEWAY dev br-mgmt

# add any elastic IPs assigned
${add-public-ips-command}
${add-private-ips-command}
