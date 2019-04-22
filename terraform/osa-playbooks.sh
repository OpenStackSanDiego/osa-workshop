eval `ssh-agent`
ssh-add ~/.ssh/default.pem
( cd /opt/openstack-ansible ; ./scripts/pw-token-gen.py --file /etc/openstack_deploy/user_secrets.yml)
cd /opt/openstack-ansible/playbooks/
openstack-ansible setup-infrastructure.yml --syntax-check
openstack-ansible setup-hosts.yml
openstack-ansible setup-infrastructure.yml
openstack-ansible setup-openstack.yml
