# Lab 08 - Logging

## Goals

* Understand where OSA stores logs and how to access to troubleshoot

## Prerequisites

* Access to the lab master server from Lab 01

## Access the infra host

OpenStack Ansible (OSA) runs its services within Linux Containers (LXC) to provide for segmentation, isolation, and general ease of management. We're going to walk you through all the running containers.

Log into the infra host from the lab master.

```
osa02@osa-lab-master:~/terraform$ terraform output
osa02@osa-lab-master:~/terraform$ ssh root@<your infra0 IP> -i default.pem
```


## Access the infra host

List all the running containers on the infra host.

## Physical Host Log Directory

Each physical host has the logs from its service containers mounted at /openstack/log/.

```
root@infra0:/openstack/log# ls
ansible-logging                       infra0_memcached_container-6729b99f
infra0_cinder_api_container-512a8bb4  infra0_neutron_server_container-3fb7b40f
infra0_galera_container-067ceb55      infra0_nova_api_container-1f58e840
infra0_glance_container-915428ea      infra0_rabbit_mq_container-e17999f4
infra0_horizon_container-e5a36f9b     infra0_repo_container-30c86268
infra0_keystone_container-30a072f6    infra0_rsyslog_container-f68ba9c9
infra0-lxc                            infra0_utility_container-c2e7e806
```

Take a moment and look through some of the logs

## Container Log Directory

Each service container has its own logs stored at /var/log/<service_name>.

Using the ```lxc-attach``` command, view some of the log files for a few of the OpenStack services.

```
root@infra0:~# lxc-attach -n infra0_nova_api_container-1f58e840
root@infra0-nova-api-container-1f58e840:~# ls /var/log/
```

## Next Steps

Once you feel comfortable examing the log files, proceed to [Lab 9](Lab09.md)

(C) JHL Consulting LLC 2019
