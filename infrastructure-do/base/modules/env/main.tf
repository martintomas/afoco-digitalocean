terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

module "app" {
  source = "../app"

  project_name            = var.project_name
  environment             = var.environment
  do_region               = var.do_region
}
