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

provider "digitalocean" {
  token = var.do_token
  spaces_access_id = var.do_spaces_client_id
  spaces_secret_key = var.do_spaces_secret_key
}

# DO allows to have only one container registry per account
# skip this action if registry already exists
module "container_registry" {
  source = "./modules/container_registry"

  registry_name      = var.container_registry_name
  do_region          = var.do_region
}

# can be run only after container registry is created and it contains docker images
# provide correct image tag during creation of app
# docker images should be automatically build and pushed to docker registry by CI/CD
# module "staging" {
#   source                = "./modules/env"
#   project_name          = var.project_name
#   environment           = "staging"
#   do_region             = var.do_region
#   do_app_instance       = var.do_app_instance
#   do_app_instance_count = var.do_app_instance_count
#   do_app_image_tag =    = var.do_app_image_tag
# }
