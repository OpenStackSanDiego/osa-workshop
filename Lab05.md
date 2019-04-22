# Lab 05 - Horizon Access

## Goals

* Understand how to access the Horizon GUI within OSA

## Prerequisites

* Access to the lab master server from Lab 01

## Lookup the Horizon credentials and URL

OpenStack Ansible (OSA) deploys Horizon, the OpenStack GUI, for cloud administration and end user access. The GUI is available at the IP listed in the OSA configuration file and the credentials can be pulled from the secrets file.

Log into the infra host from the lab master.

```
osa02@osa-lab-master:~/terraform$ terraform output
osa02@osa-lab-master:~/terraform$ ssh root@<your infra0 IP> -i default.pem
```

Pull the administrator password from the OSA secrets file. This file was generated as part of the OSA installation.

```
grep keystone_auth_admin_password /etc/openstack_deploy/user_secrets.yml
```

Pull the external IP from the OSA configuration file.

```
grep external_lb_vip_address /etc/openstack_deploy/openstack_user_config.yml
```

## Access the Horizon GUI

The Horizon GUI can be accessed using a regular web browser at ```https://<external_lb_vip_address>/```. You'll need to click through an warning messages about an insecure certificate.

The login name will be ```admin``` and the password will the one you got from the user_secrets above.

## Next Steps

Once you're comfortable getting the Horizon details out of OSA, proceed to [Lab 6](Lab06.md)

(C) JHL Consulting LLC 2019
