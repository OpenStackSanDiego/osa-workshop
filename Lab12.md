# Lab 04 - Examine LXC Environments

## Goals

* Understand the deployed containers and how to access

## Prerequisites

* Access to the lab master server from Lab 01

## Key Maintenance

(If you haven't already)
Before we start, we need some permission cleanup on the lab key files. The files are currently owned by root and needs to be owned by your user. We'll run ```chmod``` to give you access to them.

```
osa02@osa-lab-master:~/terraform$ sudo chown `whoami` default*
```


## Examine your first Linux Containers (LXC)

OpenStack Ansible (OSA) runs its services within Linux Containers (LXC) to provide for segmentation, isolation, and general ease of management. We're going to walk you through all the running containers.

Log into the infra host from the lab master.

```
osa02@osa-lab-master:~/terraform$ terraform output
osa02@osa-lab-master:~/terraform$ ssh root@<your infra0 IP> -i default.pem
```

List all the running containers on the infra host.

```
root@infra0:~# lxc-ls
```

Attach (log into) the utility container. It has all the OpenStack utilities and RC file. The RC file has all the credentials to access this cloud. lxc support file completion - give it a try.

```
root@infra0:~# lxc-attach <utility container name>
```

Within the container:

```
more ~/openrc
source ~/openrc
openstack user list
openstack service list
```

## Next Steps

Once you feel comfortable with the deployed containers, proceed to [Lab 5](Lab05.md)

(C) JHL Consulting LLC 2019
