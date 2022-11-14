# Define required providers
terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.44.0"
    }
  }
}

# Configure the OpenStack Provider
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

# Create a web security group
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

resource "openstack_networking_network_v2" "network_1" {
  name           = "network_1"
  admin_state_up = "true"
}

# data "cloudinit_config" "lb_config" {
#   part {
#     filename     = "cloudinit.yml"
#     content_type = "text/cloud-config"
#     content      = templatefile("scripts/cloudinit.yml", {
#       sshkey = var.sshkey
#     })
#   }
#   part {
#     filename     = "lb.yml"
#     content_type = "text/cloud-config"
#     content      = templatefile("scripts/lb.yml", {
#       array_ip_agent_k3s = var.array_ip_agent_k3s
#     })
#   }
# }

data "cloudinit_config" "k3s_master_config" {
  part {
    filename     = "cloudinit.yml"
    content_type = "text/cloud-config"
    content      = templatefile("scripts/cloudinit.yml", {
      sshkey = var.sshkey
    })
  }
  part {
    filename     = "k3s_master.yml"
    content_type = "text/cloud-config"
    content      = templatefile("scripts/k3s_master.yml", {
      self_ip    = self.network[0].fixed_ip_v4
    })
  }
}

# data "cloudinit_config" "k3s_agent_config" {
#   part {
#     filename     = "cloudinit.yml"
#     content_type = "text/cloud-config"
#     content      = templatefile("scripts/cloudinit.yml", {
#       sshkey = var.sshkey
#     })
#   }
#   part {
#     filename     = "k3s_agent.yml"
#     content_type = "text/cloud-config"
#     content      = templatefile("scripts/k3s_agent.yml", {
#       array_ip_agent_k3s = var.array_ip_agent_k3s
#     })
#   }
# }

# Create K3s servers node
resource "openstack_compute_instance_v2" "k3s_master" {
  count           = var.instance_master_count
  name            = "k3s-master-${count.index + 1}"
  image_id        = "28ed80db-f1c1-4047-a57f-42a1cbb8b432" #Open SUSE
  flavor_name     = "a1-ram2-disk20-perf1"
  security_groups = ["sg-web-front"]
  user_data = data.cloudinit_config.k3s_master_config.rendered
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