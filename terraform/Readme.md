

Clone this repo.

```
cp terraform.tfvars.sample terraform.tfvars
```

```
sed -i "s/terraform_username=.*/terraform_username=\"$LOGNAME\"/g" terraform.tfvars
```

Get your **User API key** (not Project API key) following these directions under "User Level API Key":
https://support.packet.com/kb/articles/api-integrations
```
echo packet_auth_token=\"ABCDEFGHIJKLMNOPQRSTUVWXYZ123456\" >> terraform.tfvars
echo packet_project_id=\"12345678-90AB-CDEF-GHIJ-KLMNOPQRSTUV\" >> terraform.tfvars
```

Terraform - See [Terraform Download](https://www.terraform.io/downloads.html)
```
terraform init
```

```
terraform plan
```

```
terraform apply
```

```
ssh root@<control_ip> -i default.pem
```

```
more /etc/openstack_deploy/openstack_user_config.yml
more /etc/openstack_deploy/user_variables.yml
```

```
cd /opt/openstack-ansible
./scripts/pw-token-gen.py --file /etc/openstack_deploy/user_secrets.yml
```

```
cd /opt/openstack-ansible/playbooks/
openstack-ansible setup-infrastructure.yml --syntax-check
openstack-ansible setup-hosts.yml
openstack-ansible setup-infrastructure.yml
```

Verify database cluster
```
ansible galera_container -m shell -a "mysql -h localhost -e 'show status like \"%wsrep_cluster_%\";'"
```


```
openstack-ansible setup-openstack.yml
```

```
grep keystone_auth_admin_password /etc/openstack_deploy/user_secrets.yml
```

```
lxc-ls | grep utility
lxc-attach -n <container_name>
openstack user list --os-cloud=default
```

```
grep keystone_auth_admin_password /etc/openstack_deploy/user_secrets.yml
source openrc
```

```
ssh-keygen
alias os="openstack --os-cloud=default"
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
os image create --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --public cirros
os flavor create --os-cloud=default --ram 512   --disk 1   --vcpus 1 m1.tiny
os keypair create --public-key ~/.ssh/id_rsa.pub  default
os network create test-vxlan
os subnet create --network test-vxlan --subnet-range 192.168.0.0/24 test-vxlan-subnet
os server create --flavor m1.tiny --image cirros --key-name default c1
http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
```
