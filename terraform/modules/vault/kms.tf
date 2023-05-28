resource "google_kms_key_ring" "vault_key_ring" {
  project  = var.project_id
  name     = "vault-keyring-${var.suffix}"
  location = "global"
}

resource "google_kms_crypto_key" "vault_crypto_key" {
  name            = "vault-key-${var.suffix}"
  key_ring        = google_kms_key_ring.vault_key_ring.id
  rotation_period = "100000s"
}