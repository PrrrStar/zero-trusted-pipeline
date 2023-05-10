resource "random_id" "instance_id" {
  byte_length = 8
}


module "vault_server" {
  source             = "./modules/vault"
  project_id         = var.project_id
  suffix             = random_id.instance_id.hex
  machine_type       = var.machine_type
  num_instances      = var.num_instances
  zone               = var.zone
  storage_region     = var.region
  image_project      = var.image_project
  image_family       = var.image_family
  network            = var.network
  tag                = var.tag
  source_ip_range    = var.source_ip_range
  storage_ha_enabled = var.vault_storage_ha_enabled
  ui_enabled         = var.vault_ui_enabled
}