#
#Cloud ID Tag = ${cloud_id}
#
#
#Private IP Block for Control 0 = ${control_0_container_subnet}
#Private IP Block for Compute 0 = ${compute_0_container_subnet}
#Private IP Block for Project   = ${project_private_subnet}
#
*************************************

cidr_networks:
  pod1_container: 172.29.236.0/24
  pod4_container: 172.29.239.0/24
  pod1_tunnel: 172.29.240.0/24
  pod4_tunnel: 172.29.243.0/24

used_ips:
  - "172.29.236.1,172.29.236.50"
  - "172.29.237.1,172.29.237.50"
  - "172.29.245.1,172.29.245.50"
  - "172.29.246.1,172.29.246.50"

global_overrides:
  internal_lb_vip_address: internal-openstack.example.com
  #
  # The below domain name must resolve to an IP address
  # in the CIDR specified in haproxy_keepalived_external_vip_cidr.
  # If using different protocols (https/http) for the public/internal
  # endpoints the two addresses must be different.
  #
  external_lb_vip_address: openstack.example.com
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

