// ── file: google/google-project.tf ──

data "google_compute_image" "container_optimized" {
  family  = local.gcp.image.family
  project = local.gcp.image.project
  /*  name    = local.gcp.image.name */
}

provider "google" {
  project               = local.gcp.project.name
  region                = local.gcp.project.region
  zone                  = local.gcp.project.zone
  user_project_override = true
  billing_project       = local.gcp.billing.project
}

resource "google_service_account" "container_host" {
  account_id = local.gcp.account.id
}

output "project_id" {
  value = local.gcp.project.name
}

output "zone" {
  value = local.gcp.project.zone
}

output "instance_name" {
  value = local.gcp.vm.name
}

resource "google_compute_instance" "container_host" {
  name         = local.gcp.vm.name
  project      = local.gcp.project.name
  machine_type = local.gcp.vm.size
  tags         = var.firewall.proxy_tags

  allow_stopping_for_update = true

  boot_disk {
    source = google_compute_disk.boot.self_link
  }

  attached_disk {
    source      = google_compute_disk.data.self_link
    device_name = local.gcp.disk.data.vm_name
  }

  attached_disk {
    source      = google_compute_disk.swap.self_link
    device_name = local.gcp.disk.swap.tf_name
  }

  network_interface {
    network = local.gcp.project.network

    access_config {
      network_tier = "STANDARD"
    }
  }

  metadata = {
    user-data = var.cloud_config
  }

  service_account {
    email  = google_service_account.container_host.email
    scopes = ["cloud-platform"]
  }
}
