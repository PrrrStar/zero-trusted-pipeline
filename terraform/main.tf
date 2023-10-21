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

module "vault_server" {
  source             = "./modules/vault"
  project_id         = local.project
  suffix             = random_id.instance_id.hex
  machine_type       = local.vault["machine_type"]
  num_instances      = local.vault["num_instances"]
  zone               = local.vault["zone"]
  image_project      = local.vault["image_project"]
  image_family       = local.vault["image_family"]
  vpc_name           = "vpc-d-devops-main"
  subnet_name        = "sbn-d-devops-private"
  tag                = local.vault["tag"]
  source_ip_range    = local.vault["source_ip_range"]
  storage_region     = local.vault["storage_region"]
  storage_ha_enabled = local.vault["storage_ha_enabled"]
  ui_enabled         = local.vault["ui_enabled"]

  depends_on = [module.sbn]
}

module "bastion" {
  source = "./modules/bastion"

  name                           = local.bastion["name"]
  domain                         = local.domain
  env                            = local.env
  identifier                     = local.identifier
  project                        = local.project
  region                         = local.region
  zone                           = local.bastion["zone"]
  vpc_name                       = local.bastion["vpc_name"]
  subnet_name                    = local.bastion["subnet_name"]
  machine_type                   = local.bastion["machine_type"]
  source_ranges                  = local.bastion["source_ranges"]
  ports                          = local.bastion["ports"]
  address_type                   = local.bastion["address_type"]
  network_tags                   = ["bastion"]
  vault_server_primary_address   = "10.100.0.2"
  vault_server_secondary_address = "10.100.0.3"
}

module "gke" {
  for_each = { for gke in local.gke : gke["name"] => gke }

  source         = "./modules/gke"
  domain         = local.domain
  env            = local.env
  project        = local.project
  identifier     = local.identifier
  vpc_name       = each.value["vpc_name"]
  subnet_name    = each.value["sbn_name"]
  subnet_region  = each.value["sbn_region"]
  name           = each.value["name"]
  master_version = each.value["version"]
  zone           = "${each.value["sbn_region"]}-a"
  nodepool       = each.value["nodepool"]

  depends_on = [module.sbn]
}