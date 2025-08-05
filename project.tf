// ── file: /project.tf ──

terraform {
  backend "remote" {
    organization = null
    workspaces { name = null }
  }
}

module "vars" {
  source = "./vars"
}

module "firewall" {
  source      = "./google/networking"
  google_user = local.google_user
  network_id  = local.merged.gcp.project.network
}

module "google" {
  source       = "./google"
  gcp_map      = local.merged.gcp
  cloud_config = local.cloud_config
  firewall     = module.firewall
}

module "actual" {
  source      = "./modules/actual"
  google_user = local.google_user
}

module "api" {
  source  = "./google/api"
  project = local.merged.gcp.project
}

module "duckdns" {
  source         = "./modules/duckdns"
  duckdns_token  = local.merged.duckdns.duckdns_token
  google_user    = local.google_user
  duckdns_domain = local.merged.duckdns.duckdns_domain
}

module "caddy" {
  source         = "./modules/caddy"
  google_user    = local.google_user
  duckdns_domain = local.merged.duckdns.duckdns_domain
}

module "custom" {
  source      = "./modules/custom"
  google_user = local.google_user
  paths       = local.init_dirs_paths
  commands    = local.start_commands

  devices = {
    data = local.merged.gcp.disk.data.gcp_name
    swap = local.merged.gcp.disk.swap.gcp_name
  }
}
