# Lab 10 - OSA Playbook Generator

## Goals

* Learn how this workshop generated the OSA configuration files

## Prerequisites

* Access to the lab master server from Lab 01

## Overview

Terraform and the Packet bare metal cloud were used to build these lab environments. The [Terraform Packet Provider](https://www.terraform.io/docs/providers/packet/) provides the "glue" between Terraform and the Packet APIs used to deploy physical infrastructure and setup the underlying network. The information about the deployed infrastructure (i.e. network IPs and subnets) are then used by a Terraform Template to generate the OpenStack Ansible configuration file. The end result is a rapid and highly replicable from scratch of a full OpenStack cloud from bare metal.

## Bare Metal Deployment

The two hosts, infra0 and compute0, are defined in ```BareMetal.tf```.

```
cd terraform/
more BareMetal.tf
```

## Assigned Subnets

A /25 is assigned to this project and then subnetted into multiple /28s with multiple subnets assigned to each physical host. The [Terraform cidrsubnet](https://www.terraform.io/docs/configuration/functions/cidrsubnet.html) provides this subnet math functionality.

```
more subnet.tf
```

## Building the OSA Config

All of this information is then brought together in the Terraform template ```openstack_user_config-yml.tpl``` with values set in ```openstack_user_config.tf```. The resulting configuration file is then copied over onto infra0.

```
more openstack_user_config-yml.tpl
more openstack_user_config.tf
```

# Next Steps

Once you feel comfortable how the infrastructure is built, proceed to [Lab 11](Lab11.md)

(C) JHL Consulting LLC 2019

