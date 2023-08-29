##
# Module to build the DO App
##

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

data "digitalocean_project" "project" {
  name = var.project_name
}

resource "digitalocean_app" "app" {
  spec {
    name   = "${var.project_name}-${var.environment}"
    region = var.do_region

    alert {
      rule = "DEPLOYMENT_FAILED"
    }
    alert {
      rule = "DOMAIN_FAILED"
    }

    service {
      name               = "${var.project_name}-${var.environment}-client"
      http_port          = 8080
      instance_count     = var.do_app_instance_count
      instance_size_slug = var.do_app_instance

      image {
        registry_type = "DOCR"
        repository    = "${var.project_name}-${var.environment}-client"
        tag           = var.do_app_image_tag
      }

      routes {
        path                 = "/"
        preserve_path_prefix = false
      }
    }

    service {
      name               = "${var.project_name}-${var.environment}-cms"
      http_port          = 8081
      instance_count     = var.do_app_instance_count
      instance_size_slug = var.do_app_instance

      image {
        registry_type = "DOCR"
        repository    = "${var.project_name}-${var.environment}-cms"
        tag           = var.do_app_image_tag
      }

      routes {
        path                 = "/admin"
        preserve_path_prefix = true
      }
      routes {
        path                 = "/api"
        preserve_path_prefix = true
      }
      routes {
        path                 = "/content-manager"
        preserve_path_prefix = true
      }
      routes {
        path                 = "/documentation"
        preserve_path_prefix = true
      }
      routes {
        path                 = "/i18n"
        preserve_path_prefix = true
      }
      routes {
        path                 = "/plugins"
        preserve_path_prefix = true
      }
    }
  }
}

resource "digitalocean_project_resources" "app" {
  project = data.digitalocean_project.project.id
  resources = [digitalocean_app.app.urn]
}
