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
    content = templatefile("scripts/cloudinit.yml", {
      sshkey = var.sshkey
    })
  }
  part {
    filename     = "k3s_master.yml"
    content_type = "text/cloud-config"
    content = templatefile("scripts/k3s_master.yml", {
      self_ip = self.network[0].fixed_ip_v4
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
