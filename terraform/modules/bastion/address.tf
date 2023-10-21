resource "google_compute_address" "main" {
  name         = "ing-${var.env}-${var.domain}-${var.name}"
  project      = var.project
  address_type = var.address_type
  subnetwork   = var.subnet_name
  region       = var.region
  purpose      = "GCE_ENDPOINT"
}