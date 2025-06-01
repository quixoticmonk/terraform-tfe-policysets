terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.40.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0"
    }
  }
}
