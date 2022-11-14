output "masters_ip" {
  value = openstack_compute_instance_v2.k3s_master[*].network[*].fixed_ip_v4
}
