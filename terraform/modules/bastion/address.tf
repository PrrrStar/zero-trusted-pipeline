resource "google_compute_address" "main" {
  name         = "ing-${var.env}-${var.domain}-${var.identifier}"
  project      = var.project
  region       = var.region
  address_type = var.type
}
