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
