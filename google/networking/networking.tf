// ── file: google/networking/networking.tf ──

variable "google_user" { type = string }
variable "network_id" { type = string }

locals {
  firewall_rules_list = [
    for f in data.local_file.fw :
    yamldecode(f.content)
  ]

  firewall_rules = merge(
    local.firewall_rules_list...
  )

  proxy_tags = flatten([
    for rule in values(local.firewall_rules) : rule.target_tags
  ])
}

data "local_file" "fw" {
  for_each = fileset("${path.module}/firewall", "*.yaml")
  filename = "${path.module}/firewall/${each.value}"
}

resource "google_compute_firewall" "rules" {
  for_each = local.firewall_rules
  project  = var.google_user
  name     = each.value.name
  network  = google_compute_network.vpc_network.name
  priority = each.value.priority

  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  target_tags   = each.value.target_tags
  source_ranges = each.value.source_ranges
}

resource "google_compute_network" "vpc_network" {
  name = var.network_id
  project = var.google_user
}

output "proxy_tags" {
  value       = local.proxy_tags
  description = "All tags to apply to instances that need firewall access."
}

output "firewall_rules" {
  value       = local.firewall_rules
  description = "Map of decoded firewall rules from YAML."
}
