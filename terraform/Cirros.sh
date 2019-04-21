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
