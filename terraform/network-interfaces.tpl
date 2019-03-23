
# Container management bridge
auto br-mgmt
iface br-mgmt inet static
    bridge_stp off
    bridge_waitport 0
    bridge_fd 0
    offload-sg off
    bridge_ports bond0:0
    address ${br-mgmt-ip}
    netmask 255.255.255.254
