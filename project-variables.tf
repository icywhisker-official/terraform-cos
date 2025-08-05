// ── file: /project-variables.tf ──

locals {
  merged = {
    duckdns = module.vars.duckdns_vars_map
    gcp     = module.vars.gcp_vars_map
  }

  google_user     = local.merged.gcp.account.username
  init_dirs_paths = values(local.mkdir_list)

  mkdir_list = {
    actual_data    = module.actual.actual_data
    duckdns_data   = module.duckdns.duckdns_data
    caddy_dir      = module.caddy.caddy_dir
    caddy_data     = module.caddy.caddy_data
    caddy_config   = module.caddy.caddy_config
    docker_compose = "/mnt/disks/data/docker-compose"
    persistent     = "/mnt/disks/data/persist"
  }

  services_to_start = [
    "actual",
    "duckdns",
    "caddy",
  ]

  start_commands = concat(
    ["systemctl daemon-reload"],
    [for svc in local.services_to_start : "systemctl start ${svc}.service"]
  )

  cloud_config = <<-EOT
#cloud-config
${yamlencode({
  write_files = concat(
    module.custom.write_files,
    module.actual.write_files,
    module.duckdns.write_files,
    module.caddy.write_files
  ),  # ← comma added here
  bootcmd = [
    "fsck.ext4 -tvy ${local.merged.gcp.disk.data.gcp_name}",
    "mkdir -p /mnt/disks/data",
    "mount -t ext4 -o nodev,nosuid ${local.merged.gcp.disk.data.gcp_name} /mnt/disks/data"
  ]
})}
  EOT
}

variable "google" {
  type = object({
    google_username = optional(string)
    google_project  = optional(string)
    google_billing  = optional(string)
  })
  default = {}
}

variable "duckdns" {
  type = object({
    duckdns_subdomain = optional(string)
    duckdns_token     = optional(string)
  })
  default = {}
  sensitive = true
}

output "project_id" {
  value = local.merged.gcp.project.name
}

output "zone" {
  value = local.merged.gcp.project.zone
}

output "instance_name" {
  value = local.merged.gcp.vm.name
}
