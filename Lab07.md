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
root@infra0:~# ansible galera_container -m shell -a "mysql -h 127.0.0.1 -e 'show status like \"%wsrep_cluster_%\";'"
```
alternatively, you can inspect the lxc container directly:

```
root@infra0:~# lxc-attach  infra0_galera_container-#######

root@infra0-galera-container-53af11c4:~# mysql -h 127.0.0.1 -e 'show status like "%wsrep_cluster_%";' 
+--------------------------+--------------------------------------+
| Variable_name            | Value                                |
+--------------------------+--------------------------------------+
| wsrep_cluster_conf_id    | 1                                    |
| wsrep_cluster_size       | 1                                    |
| wsrep_cluster_state_uuid | 7b663ae7-69d4-11e9-a963-e630c933d533 |
| wsrep_cluster_status     | Primary                              |
+--------------------------+--------------------------------------+
```


## Next Steps

Once you feel comfortable, proceed to [Lab 8](Lab08.md)

(C) JHL Consulting LLC 2019
