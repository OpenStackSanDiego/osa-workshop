# setup bridges required for OSA
# this script is intended to be called by Terraform

cat >> /etc/network/interfaces <<EOF
# Container management bridge
auto br-mgmt
iface br-mgmt inet static
    bridge_stp off
    bridge_waitport 0
    bridge_fd 0
    offload-sg off
    # Bridge port references tagged interface
    bridge_ports eno2
    address 172.29.236.1
    netmask 255.255.252.0
EOF
