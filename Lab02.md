# Lab 02 - Examine Network Setup

## Goals

* Examine the network configuration on the deployed infrastructure (targets)

## Prerequisites

* Access to the lab master server from Lab 01
* Validate that all server instances are running OK from Lab 01

## Overview

Before installing OpenStack-Ansible (OSA), the target hardware networking needs to be setup according to the documentation listed at:

https://docs.openstack.org/project-deploy-guide/openstack-ansible/rocky/targethosts.html

We've taken the liberty to setup this networking on the target host already. We're going to walk that networking configuration on the deployed target hosts.

## Key Maintenance

Before we start, we need some permission cleanup on the lab key files. The files are currently owned by root and needs to be owned by your user. We'll run ```chmod``` to give you access to them.

```
osa02@osa-lab-master:~/terraform$ sudo chown `whoami` default*
```

## Examine Networking

You'll be looking at the networking on infra0 and compute0 to see how it is setup for OSA. Take note of the IP address while you're logged into the osa-master as output from Terraform.

```
terraform output
```

### Virtual Network Bridges

The following two network bridges are required for our OSA installation (br-mgmt and br-vxlan).

| Bridge name   | Configure On           | Static IP? | Use                        |
| ------------- | ---------------------- | ---------- |----------------------------|
| br-mgmt       | compute & infra nodes  | yes        | Control plane              |
| br-vxlan      | compute & infra nodes  | yes        | Tenant tunnel networking   |

### Physical Interfaces

For redudancy, the target host is configured with two physical interfaces that have been bonded together. The uplinks are to two independent top of rack switches.

### Examine infra0 networking

Log into infra0 from the lab master using the provided keys

```
ssh root@147.75.67.197 -i default.pem
```

Examine the bond0 interface.

```
ip link show bond0
```

Examine the br-mgmt and br-vxlan bridges and verify they have an IP address.

```
ip a show br-mgmt
ip a show br-vxlan
```

### Examine compute0 networking

Log into compute0 from the lab master using the provided keys

```
ssh root@27.75.67.27 -i default.pem
```

Examine the bond0 interface.

```
ip link show bond0
```

Examine the br-mgmt and br-vxlan bridges and verify they have an IP address.

```
ip a show br-mgmt
ip a show br-vxlan
```


## Bridge Setup Commands

The commands to setup these bridges were run from a file called ```setup-bridges.sh```. This file was automatically created by Terraform with the correct IP addresses allocated to this physical hardware host. Take a look to become familiar with the commands required to setup this networking. This includes how the bridge was created and how an IP address was assigned to the bridge.


## Next Steps

Once you're done and feel understand the deployed network configuration, proceed to [Lab 3](Lab03.md)

(C) JHL Consulting LLC 2019
