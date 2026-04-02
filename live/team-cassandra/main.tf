# This tells Terraform who the provider is
terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.2-rc07"
      
    }
  }
}

variable "proxmox_api_url" { type = string }
variable "proxmox_api_token_id" { type = string }
variable "proxmox_api_token_secret" { 
  type      = string 
  sensitive = true 
}

# The Provider now uses these variables
provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = true
  pm_parallel     = 3
}

# The Module Call
module "Cassandra_infra" {
  source = "../../modules/dp_module"

  team_name = "cassandra"
  vms = {
    "database" = {
      vmid  = 701,
      memory    = 4192,
      disk_size = "15G"
    },

    "frontend" = {
      vmid      = 702, 
      memory    = 4192,
      disk_size = "15G"
    }

  }

  docker_image   = "cassandra:latest"
  admin_user     = var.proxmox_user 
  admin_password = var.proxmox_password
}

# These variables pass the sensitive info from your env/tfvars to the module
variable "proxmox_user" {}
variable "proxmox_password" {}