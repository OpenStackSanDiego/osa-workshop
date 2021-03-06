# Copyright 2019 JHL Consulting LLC
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

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
# Host IPs:
# infra0_private_addr    = ${infra0_private_addr}
# infra0_public_addr     = ${infra0_public_addr}
#
# compute0_private_addr  = ${compute0_private_addr}
# compute0_public_addr   = ${compute0_public_addr}
#
# Assigned subnets:
# infra0_container_subnet   = ${infra0_container_subnet}
# compute0_container_subnet = ${compute0_container_subnet}
#

cidr_networks:
  infra0_container_subnet:   ${infra0_container_subnet}
  infra0_tunnel_subnet:      ${infra0_tunnel_subnet}
  compute0_container_subnet: ${compute0_container_subnet}
  compute0_tunnel_subnet:    ${compute0_tunnel_subnet}

used_ips:
  - ${infra0_public_addr}
  - ${compute0_public_addr}
  - ${infra0_private_addr}
  - ${compute0_private_addr}
  - ${infra0_container_gw}
  - ${infra0_tunnel_gw}
  - ${compute0_container_gw}
  - ${compute0_tunnel_gw}

global_overrides:
  # right now these both point to a single infra0 host
  # they should eventually point to a group of infra hosts
  internal_lb_vip_address: ${infra0_private_addr}
  external_lb_vip_address: ${infra0_public_addr}

  management_bridge: "br-mgmt"
  provider_networks:
    - network:
        container_bridge: "br-mgmt"
        container_type: "veth"
        container_interface: "eth1"
        ip_from_q: "infra0_container_subnet"
        address_prefix: "container"
        type: "raw"
        group_binds:
          - all_containers
          - hosts
        reference_group: "infra0_hosts"
        is_container_address: true
        static_routes:
          # Route to container networks
          - cidr: ${infra0_container_subnet}
            gateway: ${infra0_container_gw}
    - network:
        container_bridge: "br-mgmt"
        container_type: "veth"
        container_interface: "eth1"
        ip_from_q: "compute0_container_subnet"
        address_prefix: "container"
        type: "raw"
        group_binds:
          - all_containers
          - hosts
        reference_group: "compute0_hosts"
        is_container_address: true
        static_routes:
          # Route to container networks
          - cidr: ${compute0_container_subnet}
            gateway: ${compute0_container_gw}
    - network:
        container_bridge: "br-vxlan"
        container_type: "veth"
        container_interface: "eth10"
        ip_from_q: "infra0_tunnel_subnet"
        address_prefix: "tunnel"
        type: "vxlan"
        range: "1:1000"
        net_name: "vxlan"
        group_binds:
          - neutron_linuxbridge_agent
        reference_group: "infra0_hosts"
        static_routes:
          # Route to tunnel networks
          - cidr: ${infra0_tunnel_subnet}
            gateway: ${infra0_tunnel_gw}
    - network:
        container_bridge: "br-vxlan"
        container_type: "veth"
        container_interface: "eth10"
        ip_from_q: "compute0_tunnel_subnet"
        address_prefix: "tunnel"
        type: "vxlan"
        range: "1:1000"
        net_name: "vxlan"
        group_binds:
          - neutron_linuxbridge_agent
        reference_group: "compute0_hosts"
        static_routes:
          # Route to tunnel networks
          - cidr: ${compute0_tunnel_subnet}
            gateway: ${compute0_tunnel_gw}

###
### Infrastructure
###

infra0_hosts:
  infra0:
    ip: ${infra0_public_addr}

compute0_hosts:
  compute0:
    ip: ${compute0_public_addr}

# galera, memcache, rabbitmq, utility
shared-infra_hosts:
  infra0:
    ip: ${infra0_public_addr}

# repository (apt cache, python packages, etc)
repo-infra_hosts:
  infra0:
    ip: ${infra0_public_addr}

# load balancer
# Ideally the load balancer should not use the Infrastructure hosts.
# Dedicated hardware is best for improved performance and security.
haproxy_hosts:
  infra0:
    ip: ${infra0_public_addr}

# rsyslog server
log_hosts:
  infra0:
    ip: ${infra0_public_addr}


###
### OpenStack
###

# keystone
identity_hosts:
  infra0:
    ip: ${infra0_public_addr}


# cinder api services
storage-infra_hosts:
  infra0:
    ip: ${infra0_public_addr}


# glance
image_hosts:
  infra0:
    ip: ${infra0_public_addr}

# nova api, conductor, etc services
compute-infra_hosts:
  infra0:
    ip: ${infra0_public_addr}
  

# horizon
dashboard_hosts:
  infra0:
    ip: ${infra0_public_addr}


# neutron server, agents (L3, etc)
network_hosts:
  infra0:
    ip: ${infra0_public_addr}

# nova hypervisors
compute_hosts:
  compute0:
    ip: ${compute0_public_addr}


# unused servces - included as a place holder and to suppress warnings
unbound:

repo_masters:

etcd_all:

ceph-mon:

ceph-osd:

