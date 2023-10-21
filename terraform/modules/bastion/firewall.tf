resource "google_compute_firewall" "main" {
  name    = "fw-${var.env}-${var.domain}-allow--${var.name}"
  project = var.project
  network = var.vpc_name
  allow {
    protocol = var.protocol
    ports    = var.ports
  }
  source_ranges = var.source_ranges
  target_tags = [
    "bastion"
  ]
}