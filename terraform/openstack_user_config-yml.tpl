#
# This configuration is based upon https://docs.openstack.org/openstack-ansible/rocky/user/l3pods/example.html
#
# Each physical host is equippned with:
#   bond0    - two physical interfaces bonded together with a private IPv4 /31 and a public IPv4 /31
#   br-mgmt  - IPv4 private subnet with first IP assigned to to the physical host on the bridge as a gateway
#              to be used as the management network for services
#   br-vxlan - IPv4 private subnet with first IP assigned to to the physical host on the bridge as a gateway
#              to be used as the tenant tunnel network
#
#Cloud ID Tag = ${cloud_id}
#
# pod1: infra0
# pod4: compute0
#
#Private IP Block for Control 0 = ${control_0_container_subnet}
#Private IP Block for Compute 0 = ${compute_0_container_subnet}
#Private IP Block for Project   = ${project_private_subnet}
#
#MGMT Block for Compute 0
#
*************************************

cidr_networks:
  infra0_container:   ${infra0_container_cidr}
  infra0_tunnel:      ${infra0_tunnel_cidr}
  compute0_container: ${compute0_container_cidr}
  compute0_tunnel:    ${compute0_tunnel_cidr}

used_ips:
  - ${infra0_container_gw}
  - ${infra0_tunnel_gw}
  - ${compute0_container_gw}
  - ${compute0_tunnel_gw}

global_overrides:
  internal_lb_vip_address: internal-openstack.example.com   # TODO
  external_lb_vip_address: openstack.example.com            # TODO
  management_bridge: "br-mgmt"
  provider_networks:
    - network:
        container_bridge: "br-mgmt"
        container_type: "veth"
        container_interface: "eth1"
        ip_from_q: "pod1_container"
        address_prefix: "container"
        type: "raw"
        group_binds:
          - all_containers
          - hosts
        reference_group: "pod1_hosts"
        is_container_address: true
        # Containers in pod1 need routes to the container networks of other pods
        static_routes:
          # Route to container networks
          - cidr: 172.29.236.0/22 # <-  mgmt block infra0
            gateway: 172.29.236.1 # <- IP #1 of mgmt block infra0
      - network:
        container_bridge: "br-mgmt"
        container_type: "veth"
        container_interface: "eth1"
        ip_from_q: "pod4_container"
        address_prefix: "container"
        type: "raw"
        group_binds:
          - all_containers
          - hosts
        reference_group: "pod4_hosts"
        is_container_address: true
        # Containers in pod4 need routes to the container networks of other pods
        static_routes:
          # Route to container networks
          - cidr: 172.29.236.0/22 # <- mgmt block compute0
            gateway: 172.29.239.1 # <- IP #1 of mgm block compute0
    - network:
        container_bridge: "br-vxlan"
        container_type: "veth"
        container_interface: "eth10"
        ip_from_q: "pod1_tunnel"
        address_prefix: "tunnel"
        type: "vxlan"
        range: "1:1000"
        net_name: "vxlan"
        group_binds:
          - neutron_linuxbridge_agent
        reference_group: "pod1_hosts"
        # Containers in pod1 need routes to the tunnel networks of other pods
        static_routes:
          # Route to tunnel networks
          - cidr: 172.29.240.0/22
            gateway: 172.29.240.1
    - network:
        container_bridge: "br-vxlan"
        container_type: "veth"
        container_interface: "eth10"
        ip_from_q: "pod4_tunnel"
        address_prefix: "tunnel"
        type: "vxlan"
        range: "1:1000"
        net_name: "vxlan"
        group_binds:
          - neutron_linuxbridge_agent
        reference_group: "pod4_hosts"
        # Containers in pod4 need routes to the tunnel networks of other pods
        static_routes:
          # Route to tunnel networks
          - cidr: 172.29.240.0/22
            gateway: 172.29.243.1

###
### Infrastructure
###

pod1_hosts:
  infra1:
    ip: 172.29.236.10

pod4_hosts:
  compute1:
    ip: 172.29.245.10

# galera, memcache, rabbitmq, utility
shared-infra_hosts:
  infra1:
    ip: 172.29.236.10

# repository (apt cache, python packages, etc)
repo-infra_hosts:
  infra1:
    ip: 172.29.236.10

###
### OpenStack
###

# keystone
identity_hosts:
  infra1:
    ip: 172.29.236.10


# cinder api services
storage-infra_hosts:
  infra1:
    ip: 172.29.236.10


# glance
# The settings here are repeated for each infra host.
# They could instead be applied as global settings in
# user_variables, but are left here to illustrate that
# each container could have different storage targets.
image_hosts:
  infra1:
    ip: 172.29.236.11

# nova api, conductor, etc services
compute-infra_hosts:
  infra1:
    ip: 172.29.236.10
  

# horizon
dashboard_hosts:
  infra1:
    ip: 172.29.236.10


# neutron server, agents (L3, etc)
network_hosts:
  infra1:
    ip: 172.29.236.10

# nova hypervisors
compute_hosts:
  compute1:
    ip: 172.29.245.10

