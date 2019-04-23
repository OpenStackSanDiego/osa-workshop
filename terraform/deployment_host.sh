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

# OSA deployment host packages
apt-get install -y aptitude build-essential git ntp ntpdate python-dev sudo
git clone -b 18.1.1 https://git.openstack.org/openstack/openstack-ansible /opt/openstack-ansible
(cd /opt/openstack-ansible; scripts/bootstrap-ansible.sh)
cp -R /opt/openstack-ansible/etc/openstack_deploy/ /etc/openstack_deploy
exit 0
