data "google_compute_network" "main" {
  name    = "vpc-${local.env}-${local.domain}-${local.vpc["name"]}"
  project = local.project
}

data "google_compute_subnetwork" "public" {
  name    = "sbn-${local.env}-${local.domain}-public"
  project = local.project
  region  = "asia-northeast1"
}

data "google_compute_subnetwork" "private" {
  name    = "sbn-${local.env}-${local.domain}-private"
  project = local.project
  region  = "asia-northeast3"
}

module "vault_server" {
  source             = "./modules/vault"
  project_id         = local.project
  suffix             = random_id.instance_id.hex
  machine_type       = local.vault["machine_type"]
  num_instances      = local.vault["num_instances"]
  zone               = local.vault["zone"]
  image_project      = local.vault["image_project"]
  image_family       = local.vault["image_family"]
  vpc_name           = data.google_compute_network.main.name
  subnet_name        = data.google_compute_subnetwork.private.name
  tag                = local.vault["tag"]
  source_ip_range    = local.vault["source_ip_range"]
  storage_region     = local.vault["storage_region"]
  storage_ha_enabled = local.vault["storage_ha_enabled"]
  ui_enabled         = local.vault["ui_enabled"]
}

module "bastion" {
  source = "./modules/bastion"

  env         = local.env
  domain      = local.domain
  project     = local.project
  vpc_name    = data.google_compute_network.main.self_link
  subnet_name = data.google_compute_subnetwork.public.self_link
  region      = data.google_compute_subnetwork.public.region
  zone        = "${data.google_compute_subnetwork.public.region}-a"

  identifier   = "bastion"
  machine_type = "e2-medium"
  network_tags = [
    "http-server",
    "https-server",
    "bastion"
  ]
  ports          = ["22", "443", "80"]
  source_ranges  = ["0.0.0.0/0"]

  vault_server_primary_address = module.vault_server.primary_address
  vault_server_secondary_address = module.vault_server.secondary_address
}