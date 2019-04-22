# Lab 06 - Start an Instance

## Goals

* Start up a virtual instance atop the OSA instance

## Prerequisites

* Access to the lab master server from Lab 01

## Key Maintenance

(If you haven't already)
Before we start, we need some permission cleanup on the lab key files. The files are currently owned by root and needs to be owned by your user. We'll run ```chmod``` to give you access to them.

```
osa02@osa-lab-master:~/terraform$ sudo chown `whoami` default*
```

## 

### Attach to the Utility Container

The utility container has all the tools needed to start up an instance.

```
root@infra0:~# lxc-attach <utility container name>
```

### Setup OpenStack credentials

The RC file has the needed admin credentials for this cloud.
```
source ~/openrc
```

### Create the base Cirros image

The Cirros image is small and quick to deploy making it ideal for testing.

```
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
os image create --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --public cirros
rm cirros-0.4.0-x86_64-disk.img
openstack flavor create --ram 512  --disk 1   --vcpus 1 m1.tiny
```

### Setup the networking

Create a tenant private network to be used with this new instance.

```
openstack network create test-vxlan
openstack subnet create --network test-vxlan --subnet-range 192.168.0.0/24 test-vxlan-subnet
```

### Setup a default key

Create a key within OpenStack and save the private key to a file.

```
openstack keypair create default > default.pem
```

### Spin up the instance

Spin up a new instance using the key and network defined above.

```
openstack server create --flavor m1.tiny --image cirros --key-name default cirros_1
```

### Verify instance startup

Validate that the instance started up OK.

```
openstack server list
openstack server show cirros_1
```

## Next Steps

Once you're comfortable using starting instances on OSA, proceed to [Lab 7](Lab07.md)

(C) JHL Consulting LLC 2019