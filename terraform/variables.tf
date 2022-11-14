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

### Instances ###
variable "instance_master_count" {
  default = "2"
}
variable "instance_agent_count" {
  default = "3"
}

### IP Adresses ###
variable "instance_master_count" {
  default = "2"
}
