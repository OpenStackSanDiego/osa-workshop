# hardware/OS specific system setup
# this script is intended to be called by Terraform

# c2.medium.x86
# drives: 2 x 120 GB in RAID 1
# 2 x 1 GBps network bonded

# no additional RAID setup required

# MTU setup
# OpenStack likes to use jumbo frames for the tenant networking encapsulated traffic
# 1500 for the internet facing and 8990 for the private network
# to test: ping -M do -s 8900 <private_ip>

# sometimes the newline is not there at the end of a file which we need for matching...so we add one
echo >> /etc/network/interfaces

# 1500 on internet traffic
sed -i '/^iface bond0 inet6 static/,/^$/s/^$/    mtu 1500\'$'\n/' /etc/network/interfaces

# jumbo on the bond0 private network
sed -i '/^iface bond0:0 inet static/,/^$/s/^$/    mtu 8990\'$'\n/' /etc/network/interfaces
sed -i '/^    post-up route add -net 10.0.0.0\/8 gw .*/ s/$/ mtu 8990/' /etc/network/interfaces

# jumbo on the physical interfaces
sed -i '/^    bond-master bond0/,/^$/s/^$/    mtu 8990\'$'\n/g' /etc/network/interfaces

