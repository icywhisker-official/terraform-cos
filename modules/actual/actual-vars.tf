// actual variables
variable "google_user" { type = string }

locals {
  actual = { dir = "/mnt/disks/data/actual" }
  actual_compose = templatefile("${path.module}/actual-compose.yml.tpl", {
    datadir = local.actual.dir
  })

  actual_service = templatefile("${path.module}/actual.service.tpl", {
    user  = var.google_user
    dcdir = "/mnt/disks/data/docker-compose"
  })

  actual_write_files = [
    {
      path    = "/mnt/disks/data/docker-compose/actual-compose.yml",
      content = local.actual_compose
    },
    {
      path    = "/etc/systemd/system/actual.service",
      content = local.actual_service
    },
  ]
}

output "write_files" { value = local.actual_write_files }
output "actual_data" { value = local.actual.dir }
