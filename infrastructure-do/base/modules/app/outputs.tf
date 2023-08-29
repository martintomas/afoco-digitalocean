output "app_url" {
  value = digitalocean_app.app.live_url
}

output "app_domain" {
  value = digitalocean_app.app.spec.0.domains.0
}
