resource "google_storage_bucket" "vault_backend" {
  name          = "vault-storage-${var.suffix}"
  location      = var.storage_region
  force_destroy = true
}