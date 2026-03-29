terraform { 
  cloud { 
    
    organization = "NJ" 

    workspaces { 
      name = "Cassandra_infra" 
    } 
  } 
}