// custom variables
variable "devices" {
  description = "Block‐device paths for data and swap disks"
  type = object({
    data = string
    swap = string
  })
}

variable "google_user" { type = string }

variable "paths" {
  type        = list(string)
  description = "Directories to create on every boot"
}

variable "commands" {
  type        = list(string)
  description = "Shell commands to run once at instance creation"
}

locals {
  fs_prep = templatefile("${path.module}/fs-prepare.sh.tpl", {
    user = var.google_user
  })

  per_boot = templatefile("${path.module}/per-boot.sh.tpl", {
    paths     = var.paths
    data_disk = var.devices.data
    swap_disk = var.devices.swap
  })

  run_once = templatefile("${path.module}/run-once.sh.tpl", {
    commands  = var.commands
    data_disk = var.devices.data
  })

  custom_write_files = [
    {
      path        = "/var/lib/cloud/scripts/per-instance/fs-prepare.sh"
      content     = local.fs_prep
      permissions = "0544"
      owner       = "root"
    },
    {
      path        = "/var/lib/cloud/scripts/per-boot/boot-cmd.sh"
      content     = local.per_boot
      permissions = "0755"
      owner       = "root"
    },
    {
      path        = "/var/lib/cloud/scripts/per-instance/start-services.sh"
      content     = local.run_once
      permissions = "0755"
      owner       = "root"
    },
  ]
}

output "write_files" {
  value       = local.custom_write_files
  description = "Custom write_files entries"
}
