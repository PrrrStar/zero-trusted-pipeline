listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

storage "gcs" {
  bucket      = "${storage_bucket}"
  ha_enabled  = "${storage_ha_enabled}"
}

seal "gcpckms" {
  project     = "${project_id}"
  region      = "global"
  key_ring    = "vault-keyring-${suffix}"
  crypto_key  = "vault-key-${suffix}"
}

ui         = ${ui_enabled}

api_addr   = "http://INTERNAL_IP:8200"