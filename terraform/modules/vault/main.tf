data "template_file" "vault_config" {
  template = file("${path.module}/templates/vault_config.hcl.tpl")
  vars = {
    storage_bucket     = google_storage_bucket.vault_backend.name
    storage_ha_enabled = var.storage_ha_enabled
    ui_enabled         = var.ui_enabled
    suffix             = var.suffix
    project_id         = var.project_id
  }
}


data "template_file" "start_secondary_vault" {
  template = file("${path.module}/templates/run_secondary_vault.sh.tpl")
  vars = {
    vault_config_hcl = data.template_file.vault_config.rendered
  }
}

data "template_file" "start_primary_vault" {
  template = file("${path.module}/templates/run_primary_vault.sh.tpl")
  vars = {
    vault_secondary_start = data.template_file.start_secondary_vault.rendered

  }
}


resource "google_compute_instance" "vault_primary_server" {
  name                      = "vault-${var.suffix}"
  machine_type              = var.machine_type
  zone                      = var.zone
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "${var.image_project}/${var.image_family}"
    }
  }

  metadata_startup_script = data.template_file.start_primary_vault.rendered

  network_interface {
    network = var.network
    access_config {

    }
  }

  tags = ["${var.tag}-${var.suffix}"]

  service_account {
    email  = google_service_account.vault_service_account.email
    scopes = ["cloud-platform", "compute-rw", "storage-full"]
  }
}


resource "google_compute_instance" "vault_secondary_server" {
  count                     = var.num_instances - 1
  name                      = "vault-${var.suffix}-${count.index + 1}"
  machine_type              = var.machine_type
  zone                      = var.zone
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "${var.image_project}/${var.image_family}"
    }
  }

  metadata_startup_script = data.template_file.start_secondary_vault.rendered

  network_interface {
    network = var.network
    access_config {

    }
  }

  tags = ["${var.tag}-${var.suffix}"]

  service_account {
    email  = google_service_account.vault_service_account.email
    scopes = ["cloud-platform", "compute-rw", "storage-full"]
  }
}