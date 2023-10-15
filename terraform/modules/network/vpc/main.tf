resource "google_compute_network" "main" {
  name                    = var.name
  project                 = var.project
  auto_create_subnetworks = false
}