// ── file: google/api/api-vars.tf ──

variable "project" {
  type = object({
    name = string
  })
}

data "local_file" "services" {
  for_each = fileset("${path.module}/services", "*.yaml")
  filename = "${path.module}/services/${each.value}"
}

locals {
  project_services_list = [
    for f in data.local_file.services :
    yamldecode(f.content)
  ]

  project_services_enabled = [
    for svc in local.project_services_list : svc if svc.enable
  ]

  project_services_map = {
    for svc in local.project_services_enabled : svc.service => svc
  }
}

resource "google_project_service" "project" {
  for_each = local.project_services_map

  project = var.project.name
  service = each.value.service

  timeouts {
    create = each.value.timeouts.create
    update = each.value.timeouts.update
  }

  disable_on_destroy = each.value.disable_on_destroy
}

output "enabled_project_services" {
  description = "Map of all enabled GCP services from YAML"
  value       = local.project_services_map
}
