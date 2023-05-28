resource "google_compute_network" "main" {
  name                    = "vpc-${var.env}-${var.domain}-${var.name}"
  project                 = var.project
  auto_create_subnetworks = false
}