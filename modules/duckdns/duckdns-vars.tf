// duckdns variables
variable "google_user" { type = string }

variable "duckdns_token" {
  type = string
  sensitive = true
}

variable "duckdns_domain" {
  type = string
}

locals {
  duckdns           = { dir = "/mnt/disks/data/duckdns" }
  duckdns_domain = var.duckdns_domain
  duckdns_compose = templatefile("${path.module}/duckdns-compose.yml.tpl", {
    datadir           = local.duckdns.dir
    duckdns_domain    = local.duckdns_domain
    duckdns_token     = var.duckdns_token
  })

  duckdns_service = templatefile("${path.module}/duckdns.service.tpl", {
    user  = var.google_user
    dcdir = "/mnt/disks/data/docker-compose"
  })

  duckdns_write_files = [
    {
      path    = "/mnt/disks/data/docker-compose/duckdns-compose.yml",
      content = local.duckdns_compose
    },
    {
      path    = "/etc/systemd/system/duckdns.service",
      content = local.duckdns_service
    },
  ]
}

output "write_files" { value = local.duckdns_write_files }
output "duckdns_data" { value = local.duckdns.dir }
output "duckdns_domain" { value = local.duckdns_domain }
