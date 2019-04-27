# Lab 01 - Lab Access

## Prerequisites

* Laptop with SSH client (PuTTy). The Windows client can be downloaded [here](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html).

## Lab Assignment & Credentials

On the whiteboard/projector, there will be a link to an etherpad listing all the available lab environments along with the default password. Follow the link and write your name alongside a lab number (i.e. bgp03 - John Doe).

Take note of the name of the "lab master" server on the whiteboard/projector. This will be the jump server from where you will access 

If you ever need a new lab environment, return to this page and simply assign yourself a new one. Mark any old/broken lab environments as "broken/recycle" and it will be rebuilt.

## Lab Master Access

With your assigned lab username (i.e. osa03), log into the lab master server using the your assigned lab and the password. You'll need to use a SSH client (i.e. PuTTy). 

```
ssh <your_lab_username>@<lab_master_server>
```

## Verify Deployed Hardware

We've already taken the liberty of deploying a number of servers into your environment and installing the required software so you don't have to wait for the installs.
This way you can see the end result. Don't worry, you'll get a chance to deploy it all yourself shortly.

Let's verify that all your hosts are deployed OK. You should have two physical hosts deployed, a compute and an infra physical node. The "Cloud ID Tag" is just an internal lab reference so we an track which physical hardware nodes are associated with which student lab environments.

```
cd terraform
terraform output
```

```
Cloud ID Tag = 78c60203
Compute public IPs = [
    27.75.192.67
]
Infra/Control public IPs = [
    27.75.192.153
]
Project ID = 2c2fb812-5add-4221-a14e-7ad10805be4c
SSH Access to compute0 = ssh root@27.75.192.67 -i default.pem
SSH Access to infra0 = ssh root@27.75.192.153 -i default.pem

```

And let's do a quick network connectivity check to each host.

```
ping -c 5 <compute public IP>
ping -c 5 <infra public IP>
```

You should see something like:
```
osa03@lab-master:~/terraform$ ping -c 5 27.75.194.9
PING 147.75.194.9 (147.75.194.9) 56(84) bytes of data.
64 bytes from 27.75.194.9: icmp_seq=1 ttl=60 time=0.206 ms
64 bytes from 27.75.194.9: icmp_seq=2 ttl=60 time=0.121 ms
64 bytes from 27.75.194.9: icmp_seq=3 ttl=60 time=0.183 ms
64 bytes from 27.75.194.9: icmp_seq=4 ttl=60 time=0.119 ms
64 bytes from 27.75.194.9: icmp_seq=5 ttl=60 time=0.176 ms
```

All the hosts should reply back from the ping requests. If, for some reason, your hosts are not responding, please go back and pick a different lab assignment and reverify.

## Next Steps

Once you've validated your environment, proceed to [Lab 2](Lab02.md)

(C) JHL Consulting LLC 2019
