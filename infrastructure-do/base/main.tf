terraform {
  backend "s3" {
    endpoint                    = "fra1.digitaloceanspaces.com"
    bucket                      = "afoco-terraform-state"
    region                      = "us-west-1"
    key                         = "state"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }

  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

module "staging" {
  source             = "./modules/env"
  project_name       = var.project_name
  environment        = "staging"
}
