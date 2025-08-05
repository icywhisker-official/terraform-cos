// ── file: google/google-vars.tf ──

variable "gcp_map" {
  description = "Full GCP config map from the vars module"
  type        = any
}

variable "cloud_config" {
  description = "Cloud-init user data (cloud-config)"
  type        = string
}

variable "firewall" {
  description = "Firewall configuration object"
  type = object({
    proxy_tags   = list(string)
  })
}

locals {
  gcp = var.gcp_map
}
