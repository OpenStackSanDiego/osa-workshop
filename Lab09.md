# Lab 09 - Running Playbooks

## Goals

* Understand how to execute OSA playbooks

## Prerequisites

* Access to the lab master server from Lab 01

## Overview

OpenStack Ansible uses a number of playbooks to spin up and modify the cloud. We're going to run through the basic playbooks.

## Access the infra host

OpenStack Ansible (OSA) runs its services within Linux Containers (LXC) to provide for segmentation, isolation, and general ease of management. We're going to walk you through all the running containers.

Log into the infra host from the lab master.

```
osa02@osa-lab-master:~/terraform$ terraform output
osa02@osa-lab-master:~/terraform$ ssh root@<your infra0 IP> -i default.pem
```

## openstack-ansible

The ```openstack-ansible``` command is a wrapper that setups up the required variables for ansible to run. You'll be running ```openstack-ansible``` rather than the ansible executable directly.

## Check Syntax

Once of the options is ```--syntax-check``` which verifies that the playbook is syntactically correct. 

```
cd /opt/openstack-ansible/playbooks/
openstack-ansible setup-infrastructure.yml --syntax-check
```

## Health Checks

There are a number of health check playbooks to verify the status of the cloud. 

```
root@infra0:~# cd /opt/openstack-ansible/playbooks/
root@infra0:/opt/openstack-ansible/playbooks# ls *healthcheck*
healthcheck-hosts.yml  healthcheck-infrastructure.yml  healthcheck-openstack.yml
root@infra0:/opt/openstack-ansible/playbooks# openstack-ansible healthcheck-infrastructure.yml
```

## Next Steps

Once you feel comfortable with the playbooks, proceed to [Lab 10](Lab10.md)

(C) JHL Consulting LLC 2019

