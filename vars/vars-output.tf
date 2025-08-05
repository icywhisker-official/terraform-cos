// vars output map

output "gcp_vars_map" {
  value = {
    account = {
      username = var.google.google_username
      id       = "container-host-sa-indev"
    }
    project = {
      name    = var.google.google_project
      region  = "us-east1"
      zone    = "us-east1-c"
      network = "vpc-network-indev"
    }
    billing = {
      project   = var.google.google_billing
      alert     = "5"
      currency  = "USD"
      display   = "Monthly Budget Alert"
      account   = "My Billing Account"
      threshold = {
        "1" = 0.5
        "2" = 0.9
        "3" = 1.0
        "4" = 1.5
      }
    }
    vm = {
      name = "cos-indev"
      size = "e2-micro"
    }
    image = {
      project = "cos-cloud"
      family  = "cos-stable"
      name    = null # You can specifiy a target COS boot image here e.g. "cos-stable-version-1.2.3", To apply this, swap out the commented lines between family and name - google module in google-project.tf
    }
    disk = {
      type = "pd-standard"
      boot = {
        tf_name  = null
        gcp_name = "cos-boot-disk-indev"
        size     = "10"
      }
      swap = {
        tf_name  = "cos-swap-disk-indev"
        gcp_name = "/dev/disk/by-id/google-cos-swap-disk-indev"
        size     = "2"
      }
      data = {
        tf_name  = "cos-data-disk-indev"
        vm_name  = "cos-data-disk-indev"
        gcp_name = "/dev/disk/by-id/google-cos-data-disk-indev"
        size     = "1"
        keep     = "14"
        backup   = "03:00"
        snapshot = "data-disk-snapshot-policy-indev"
      }
    }
  }
  description = "Map of GCP configuration variables"
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

output "duckdns_vars_map" {
  value = {
    duckdns_token  = var.duckdns.duckdns_token
    duckdns_domain = var.duckdns.duckdns_subdomain
  }
}
