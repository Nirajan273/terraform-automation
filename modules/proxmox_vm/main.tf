resource "proxmox_vm_qemu" "ubuntu_server" {
  count       = var.vm_count
  name        = "${var.team_name}-${format("%03d", count.index + 1)}"
  target_node = var.target_node
  vmid        = var.starting_vmid + count.index
  
  clone       = "ubuntu-jammy-template"
  full_clone  = true

  # Hardware Settings
  scsihw   = "virtio-scsi-pci"
  boot     = "order=scsi0"
  agent    = 1 
  memory   = var.memory_mb

  cpu { 
        cores = var.cpu_cores
        type = "host"
        }

  # Disk Configuration (Note: slot must be a number)
  disk {
    slot    = "scsi0"             # 0 corresponds to scsi0
    size    = var.disk_size
    type    = "disk"        # Change type to 'scsi' for the main drive
    storage = "local-lvm"
  }

  # Cloud-Init Drive
  disk {
    slot    = "ide1"            # 1 corresponds to ide1
    type    = "cloudinit"
    storage = "local-lvm"
    size    = "1M"
  }

  # Network Configuration
  network {
    id = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Cloud-Init Settings
  os_type      = "cloud-init"
  ipconfig0    = "ip=dhcp"
  ciuser       = var.admin_user
  cipassword   = var.admin_password

  # Display Settings
  vga { type = "serial0" }
  
  serial {
    id   = 0
    type = "socket" # 'type' is required by the provider
  }

  # --- Provisioning ---

  # 1. Wait for SSH to be ready
  provisioner "remote-exec" {
    inline = ["echo 'SSH is ready'"]

    connection {
      type     = "ssh"
      user     = var.admin_user
      password = var.admin_password
      host     = self.ssh_host
    }
  }

  # 2. Run Ansible from WSL
  provisioner "local-exec" {
    command = <<EOT
      export ANSIBLE_HOST_KEY_CHECKING=False
      export SSHPASS='${var.admin_password}'
      ansible-playbook -i ${self.ssh_host}, \
      -u ${var.admin_user} \
      --extra-vars "ansible_password=${var.admin_password} ansible_become_password=${var.admin_password} docker_image=${var.docker_image}" \
      ../../ansible/site.yml
    EOT
  }
}