resource "google_service_account" "vault_service_account" {
  account_id   = "vault-sa-${var.suffix}"
  display_name = "vault-sa-${var.suffix}"
}


data "google_iam_policy" "storage_admin" {
  binding {
    role = "roles/storage.admin"
    members = [
      "serviceAccount:${google_service_account.vault_service_account.email}"
    ]
  }
}

resource "google_storage_bucket_iam_policy" "vault_bucket_policy" {
  bucket      = google_storage_bucket.vault_backend.name
  policy_data = data.google_iam_policy.storage_admin.policy_data
}


resource "google_kms_key_ring_iam_binding" "vault_iam_kms_binding" {
  key_ring_id = google_kms_key_ring.vault_key_ring.id
  role        = "roles/owner"

  members = [
    "serviceAccount:${google_service_account.vault_service_account.email}",
  ]
}


data "google_iam_policy" "vault_crypto_key_encrypter_decrypter" {
  binding {
    role = "roles/owner"

    members = [
      "serviceAccount:${google_service_account.vault_service_account.email}"
    ]
  }
}

resource "google_kms_crypto_key_iam_policy" "vault_crypto_key" {
  crypto_key_id = google_kms_crypto_key.vault_crypto_key.id
  policy_data   = data.google_iam_policy.vault_crypto_key_encrypter_decrypter.policy_data
}


resource "google_project_iam_binding" "vault_crypto_encrypter_decrypter" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${google_service_account.vault_service_account.email}"
  ]
}