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

# OS specific setup 
# configuring the operating system as per the OSA target hosts prepare guide as per:
# https://docs.openstack.org/project-deploy-guide/openstack-ansible/rocky/targethosts-prepare.html
# this script is intended to be called by Terraform

apt-get update
apt-get install -y bridge-utils debootstrap ifenslave ifenslave-2.6 \
  lsof chrony sudo tcpdump vlan python
echo '8021q' >> /etc/modules-load.d/openstack-ansible.conf

# openstack - for console login
usermod --password Ym1Sx4Sc8lvEw root
