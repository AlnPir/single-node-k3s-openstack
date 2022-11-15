terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.44.0"
    }
  }
}

provider "openstack" {
  auth_url          = var.auth_url
  region            = var.region
  user_name         = var.user_name
  password          = var.password
  user_domain_name  = var.user_domain_name
  project_domain_id = var.project_domain_id
  tenant_id         = var.tenant_id
  tenant_name       = var.tenant_name
}

resource "openstack_compute_secgroup_v2" "sg-web-front" {
  name        = "sg-web-front"
  description = "Security group for web front instances"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

# resource "openstack_networking_network_v2" "main_network" {
#   name           = "main_network"
#   admin_state_up = "true"
# }

# resource "openstack_networking_subnet_v2" "main_network_subnet" {
#   count      = length(var.subnets)
#   name       = "${var.subnets.index}_subnet"
#   network_id = openstack_networking_network_v2.main_network.id
#   cidr       = "192.168.${count.index + 1}.0/24"
#   ip_version = 4
# }

# resource "openstack_networking_port_v2" "port_1" {
#   name               = "port_1"
#   network_id         = openstack_networking_network_v2.main_network.id
#   admin_state_up     = "true"
#   security_group_ids = ["${openstack_compute_secgroup_v2.secgroup_1.id}"]
#   fixed_ip = {
#     "subnet_id"  = "${openstack_networking_subnet_v2.subnet_1.id}"
#     "ip_address" = "192.168.199.10"
#   }
# }

data "cloudinit_config" "cloudinit_config" {
  part {
    filename     = "cloudinit.yml"
    content_type = "text/cloud-config"
    content = templatefile("scripts/cloudinit.yml", {
      sshkey = var.sshkey
    })
  }
  # part {
  #   filename     = "k3s_master.yml"
  #   content_type = "text/cloud-config"
  #   content = templatefile("scripts/k3s_master.yml", {
  #     self_ip = self.network[0].fixed_ip_v4
  #   })
  # }
}

resource "openstack_compute_instance_v2" "instance" {
  for_each        = var.instances
  name            = each.value.name
  image_id        = each.value.image_id
  flavor_name     = each.value.flavor_name
  security_groups = each.value.security_groups
  user_data       = each.value.user_data
  network {
    name = "ext-net1"
  }
}
