# Create K3s servers node
resource "openstack_compute_instance_v2" "k3s_master" {
  count           = var.instance_master_count
  name            = "k3s-master-${count.index + 1}"
  image_id        = "28ed80db-f1c1-4047-a57f-42a1cbb8b432" #Open SUSE
  flavor_name     = "a1-ram2-disk20-perf1"
  security_groups = ["sg-web-front"]
  user_data       = data.cloudinit_config.k3s_master_config.rendered
  metadata = {
    application = "k3s_master"
  }
  network {
    name = "ext-net1"
  }
}

# Create K3s agent node
# resource "openstack_compute_instance_v2" "k3s-instance" {
#   count           = var.instance_server_count
#   name            = "k3s-agent-${count.index + 1}"
#   image_id        = "876ab00a-b2b1-4d29-8768-920c5cba13e7" #Alpine Linux
#   flavor_name     = "a1-ram2-disk20-perf1"
#   security_groups = ["sg-web-front"]
#   user_data = data.cloudinit_config.k3s_master_config.rendered
#   metadata = {
#     application = "instance"
#   }
#   network {
#     name = "ext-net1"
#   }
# }

# Create simple load-balancer
# resource "openstack_compute_instance_v2" "lb" {
#   name            = "lb"
#   image_id        = "876ab00a-b2b1-4d29-8768-920c5cba13e7" #Alpine Linux
#   flavor_name     = "a1-ram2-disk20-perf1"
#   security_groups = ["sg-web-front"]
#   user_data = data.cloudinit_config.lb_config.rendered
#   metadata = {
#     application = "lb"
#   }
#   network {
#     name = "ext-net1"
#   }
# }
