// ── file: google/google-disks.tf ──

resource "google_compute_disk" "boot" {
  name  = local.gcp.disk.boot.gcp_name
  type  = local.gcp.disk.type
  size  = local.gcp.disk.boot.size
  image = data.google_compute_image.container_optimized.self_link
}

resource "google_compute_disk" "data" {
  name = local.gcp.disk.data.tf_name
  type = local.gcp.disk.type
  size = local.gcp.disk.data.size
}

resource "google_compute_disk" "swap" {
  name = local.gcp.disk.swap.tf_name
  type = local.gcp.disk.type
  size = local.gcp.disk.swap.size
}

resource "google_compute_disk_resource_policy_attachment" "data_schedule" {
  name = google_compute_resource_policy.data_snapshot_policy.name
  disk = google_compute_disk.data.name
}

resource "google_compute_resource_policy" "data_snapshot_policy" {
  name = local.gcp.disk.data.snapshot

  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = local.gcp.disk.data.backup
      }
    }
    retention_policy {
      max_retention_days = local.gcp.disk.data.keep
    }
    snapshot_properties {
      labels = {
        created_by = "terraform"
      }
    }
  }
}
