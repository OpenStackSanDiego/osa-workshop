# setup bridges required for OSA
# this script is intended to be called by Terraform

#
# As described in:
# https://docs.openstack.org/project-deploy-guide/openstack-ansible/newton/overview-network-arch.html
#
# Sample architecture at:
# https://docs.openstack.org/project-deploy-guide/openstack-ansible/newton/app-config-test.html
#
# Management Network		172.29.236.0/22
# Tunnel (VXLAN) Network	172.29.240.0/22
# Storage Network		172.29.244.0/22
#

#cat >> /etc/network/interfaces <<EOF
#
## Container management bridge
#auto br-mgmt
#iface br-mgmt inet static
#    bridge_stp off
#    bridge_waitport 0
#    bridge_fd 0
#    offload-sg off
#    # Bridge port references tagged interface
#    bridge_ports bond0:0
#    address
#    netmask 255.255.255.254
#EOF
