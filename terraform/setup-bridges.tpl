#!/bin/sh

# Copyright 2019 JHL Consulting LLC
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


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
ip addr add ${VXLAN_IP}/28 dev br-vxlan

ip link set br-mgmt up
ip link set br-vxlan up
