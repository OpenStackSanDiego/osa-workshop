# OSA deployment host packages
apt-get install -y aptitude build-essential git ntp ntpdate python-dev sudo
git clone -b 18.1.1 https://git.openstack.org/openstack/openstack-ansible /opt/openstack-ansible
(cd /opt/openstack-ansible; scripts/bootstrap-ansible.sh)
cp -R /opt/openstack-ansible/etc/openstack_deploy/ /etc/openstack_deploy
