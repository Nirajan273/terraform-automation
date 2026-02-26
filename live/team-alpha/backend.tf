terraform { 
  cloud { 
    
    organization = "NJ" 

    workspaces { 
      name = "proxmox-infra" 
    } 
  } 
}