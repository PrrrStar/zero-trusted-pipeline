data "template_file" "init_bastion" {
  template = file("${path.module}/templates/init_bastion.sh.tpl")
  vars = {
    vault_server_primary_address   = var.vault_server_primary_address
    vault_server_secondary_address = var.vault_server_secondary_address
  }
}

resource "google_compute_instance" "main" {
  name    = var.name
  project = var.project

  zone         = var.zone
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-pro-cloud/global/images/ubuntu-pro-2204-jammy-v20221206"
      size  = var.boot_disk_size
      type  = "pd-balanced"
    }
    mode = "READ_WRITE"
  }

  tags = var.network_tags

  network_interface {
    network    = var.vpc_name
    subnetwork = var.subnet_name
    network_ip = google_compute_address.main.address
  }
  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_vtpm                 = true
  }
  labels = {
    project      = var.project
    domain       = var.domain
    env          = var.env
    zone         = var.zone
    machine_type = var.machine_type
    made_by      = "terraform"
  }
  metadata_startup_script = data.template_file.init_bastion.rendered
}