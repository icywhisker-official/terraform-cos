// caddy variables
variable "google_user" { type = string }
variable "duckdns_domain" { type = string }

locals {
  caddy = {
    dir    = "/mnt/disks/data/caddy"
    data   = "/mnt/disks/data/caddy/data"
    config = "/mnt/disks/data/caddy/config"
  }
  caddy_compose = templatefile("${path.module}/caddy-compose.yml.tpl", {
    datadir = local.caddy.dir
  })

  caddy_service = templatefile("${path.module}/caddy.service.tpl", {
    user  = var.google_user
    dcdir = "/mnt/disks/data/docker-compose"
  })

  caddy_write_files = [
    {
      path    = "/mnt/disks/data/docker-compose/caddy-compose.yml",
      content = local.caddy_compose
    },
    {
      path    = "/etc/systemd/system/caddy.service",
      content = local.caddy_service
    },
    {
      path    = "${local.caddy.dir}/Caddyfile",
      content = <<-EOF
        "https://${var.duckdns_domain}" {
          encode gzip zstd
          reverse_proxy actual:5006
        }
        EOF
    },
  ]
}

output "write_files" { value = local.caddy_write_files }

output "caddy_dir" { value = local.caddy.dir }

output "caddy_data" { value = local.caddy.data }

output "caddy_config" { value = local.caddy.config }
