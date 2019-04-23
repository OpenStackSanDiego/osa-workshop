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

source ~/openrc
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
openstack image create --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 \
	--container-format bare --public cirros
rm cirros-0.4.0-x86_64-disk.img
openstack flavor create --os-cloud=default --ram 512   --disk 1   --vcpus 1 m1.tiny
openstack keypair create default > default.pem
openstack network create test-vxlan
openstack subnet create --network test-vxlan --subnet-range 192.168.0.0/24 test-vxlan-subnet
openstack server create --flavor m1.tiny --image cirros --key-name default c1
openstack server create --flavor m1.tiny --image cirros --key-name default c2
