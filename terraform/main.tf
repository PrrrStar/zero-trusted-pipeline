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