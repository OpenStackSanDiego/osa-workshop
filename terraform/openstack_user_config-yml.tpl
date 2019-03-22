---
cidr_networks: &cidr_networks
  container: ${container_nw}

used_ips:
  - ${all_host_private_ips}
  - ${all_host_public_ips}

global_overrides:
  cidr_networks: *cidr_networks
  #
  # The below domain name must resolve to an IP address
  # in the CIDR specified in haproxy_keepalived_external_vip_cidr.
  # If using different protocols (https/http) for the public/internal
  # endpoints the two addresses must be different.
  #
  tunnel_bridge: "br-mgmt"
  management_bridge: "br-mgmt"
  provider_networks:
    - network:
        container_bridge: "br-mgmt"
        container_type: "veth"
        container_interface: "eth1"
        ip_from_q: "container"
        type: "vxlan"
        range: "1:1000"
        net_name: "vxlan"
        group_binds:
          - all_containers
          - hosts
        is_container_address: true
        is_ssh_address: true
        static_routes:
          # Route to container networks
          - cidr: ${container_nw}
            gateway: ${private_gw}
    - network:
        container_bridge: "br-flat"
        container_type: "veth"
        container_interface: "eth12"
        container_mtu: 8900
        host_bind_override: vup-flat
        type: "flat"
        net_name: "flat"
        group_binds:
          - neutron_linuxbridge_agent

###
### Infrastructure
###

_infrastructure_hosts: &infrastructure_hosts
  ${infrastructure_hosts}

shared-infra_hosts: *infrastructure_hosts
repo-infra_hosts: *infrastructure_hosts
haproxy_hosts: *infrastructure_hosts
identity_hosts: *infrastructure_hosts
image_hosts: *infrastructure_hosts
compute-infra_hosts: *infrastructure_hosts
dashboard_hosts: *infrastructure_hosts
network_hosts: *infrastructure_hosts

# nova hypervisors
compute_hosts: &compute_hosts
  ${compute_hosts}
