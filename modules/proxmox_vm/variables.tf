variable "team_name" {
  type        = string
  description = "The name of the team (used for VM naming)"
}

variable "vm_count" {
  type        = number
  default     = 1
}

variable "target_node" {
  type        = string
  default     = "nj" # Change to your Proxmox node name
}

variable "starting_vmid" {
  type        = number
  description = "The first VM ID to use (e.g., 400)"
}

variable "admin_user" {
  type    = string
  default = "nirajan"
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "docker_image" {
  type        = string
  description = "The Docker image to deploy via Ansible"
}

variable "memory_mb" {
  type    = number
  default = 2048
}

variable "cpu_cores" {
  type    = number
  default = 2
}

variable "disk_size" {
  type    = string
  default = "10G"
}