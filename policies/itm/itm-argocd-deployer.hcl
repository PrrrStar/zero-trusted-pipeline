path "gke/dev/+/*" {
  capabilities = ["read", "list"]
}

path "gke/stage/+/*" {
  capabilities = ["read", "list"]
}

path "gke/prod/+/*" {
  capabilities = ["read", "list"]
}