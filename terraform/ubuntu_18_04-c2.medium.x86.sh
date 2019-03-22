# hardware/OS specific system setup
# this script is intended to be called by Terraform

# c2.medium.x86
# boot drives: 2 x 120 GB
# storage drives: 2 x 480 GB
# 2 x 10 GBps network bonded

# RAID setup - bring up the two storage drives as a mirror on /openstack for OSA
apt-get install parted -y
DISKS=`parted /dev/sda print devices | grep 480GB | awk '{print $1}'`
mdadm --create /dev/md127 --level=0 --raid-devices=2 $DISKS
mdadm --detail --scan --verbose > /etc/mdadm/mdadm.conf
mkfs.ext4 /dev/md127
mkdir /openstack/
UUID=`blkid -s UUID -o value /dev/md127`
cat >> /etc/fstab <<EOF
UUID=$UUID       /openstack/   ext4    defaults        0 0
EOF
mount -a



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

