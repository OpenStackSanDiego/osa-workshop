# Lab 07 - Galera cluster maintenance

## Goal

* Learn to manage the Galera database cluster within OSA
* Add an additional anycast IPv6 address

## Prerequisites

* Access to the lab master server from Lab 01

### Examine Galera Instance

## Accessing the Galera Container

OpenStack Ansible (OSA) runs the Galera database within an LXC container. We're going to walk you through checking the database status.

Log into the infra host from the lab master.

```
osa02@osa-lab-master:~/terraform$ terraform output
osa02@osa-lab-master:~/terraform$ ssh root@<your infra0 IP> -i default.pem
```

List all the running Galera containers on the infra host.
```
root@infra0:~# lxc-ls | grep -i galera
```

## Verify the cluster status

All of the Galera instances within the cluster can be verified with the following command.

```
root@infra0:~# ansible galera_container "mysql -h 127.0.0.1 \
-e 'show status like \"%wsrep_cluster_%\";'"
```

## Next Steps

Once you feel comfortable, proceed to [Lab 8](Lab08.md)

(C) JHL Consulting LLC 2019
