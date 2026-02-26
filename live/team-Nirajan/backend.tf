terraform { 
  cloud { 
    
    organization = "NJ" 

    workspaces { 
      name = "team-nirajan-proxmox" 
    } 
  } 
}