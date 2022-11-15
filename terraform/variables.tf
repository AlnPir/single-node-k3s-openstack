### Provider ###
variable "auth_url" {
  type = string
}
variable "region" {
  type = string
}
variable "user_name" {
  type = string
}
variable "password" {
  type = string
}
variable "user_domain_name" {
  type = string
}
variable "project_domain_id" {
  type = string
}
variable "tenant_id" {
  type = string
}
variable "tenant_name" {
  type = string
}
variable "sshkey" {
  type = string
}

### Values ###

# variable "subnets" {
#   type    = list(string)
#   default = ["lb", "k3s", "db", "bastion", "monitoring", "provisioning", "firewall"]
# }

# variable "cloudinit_config" {
#   type = list(object({
#     name            = string
#     count           = optional(number, 1)
#     image_id        = optional(string, "28ed80db-f1c1-4047-a57f-42a1cbb8b432")
#     flavor_name     = optional(string, "a1-ram2-disk20-perf1")
#     security_groups = list
#     user_data       = string
#   }))
# }

variable "instances" {
  type = map(object({
    name            = string
    image_id        = optional(string, "28ed80db-f1c1-4047-a57f-42a1cbb8b432")
    flavor_name     = optional(string, "a1-ram2-disk20-perf1")
    security_groups = list(string)
    user_data       = string
  }))

  default = {
    "load-balancer" = {
      name            = "load-balancer"
      security_groups = ["sg-web-front"]
      user_data       = "data.cloudinit_config.lb_config.rendered"
    },
    "k3s-master-node-1" = {
      name            = "k3s-master-node-1"
      security_groups = ["sg-web-front"]
      user_data       = "data.cloudinit_config.k3s_master_config.rendered"
    },
    "k3s-master-node-2" = {
      name            = "k3s-master-node-2"
      security_groups = ["sg-web-front"]
      user_data       = "data.cloudinit_config.k3s_master_config.rendered"
    },
  }
}
