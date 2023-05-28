locals {
  config = yamldecode(file("./${var.project}.tfvars.yaml"))

  domain     = local.config["domain"]
  env        = local.config["env"]
  region     = local.config["region"]
  project    = var.project
  identifier = local.config["identifier"]

  vpc = local.config["vpc"]
  sbn = local.config["vpc"]["subnet"]

  vault   = local.config["vault"]
  bastion = local.config["bastion"]
  gke     = local.config["gke"]
}

module "vpc" {
  source  = "./modules/network/vpc"
  domain  = local.domain
  env     = local.env
  project = local.project
  name    = local.vpc["name"]
}

module "sbn" {
  for_each                      = { for sbn in local.sbn : sbn["name"] => sbn }
  source                        = "./modules/network/sbn"
  domain                        = local.domain
  env                           = local.env
  project                       = local.project
  region                        = each.value["region"]
  vpc_self_link                 = module.vpc.self_link
  subnet_ip_range               = each.value["primary_ip_range"]
  subnet_secondary_ip_pod_range = each.value["secondary_ip_pod_range"]
  subnet_secondary_ip_svc_range = each.value["secondary_ip_svc_range"]
  name                          = each.value["name"]

  depends_on = [module.vpc]
}

resource "random_id" "instance_id" {
  byte_length = 6
}

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