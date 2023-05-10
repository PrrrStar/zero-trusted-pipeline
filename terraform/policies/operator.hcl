path "github/+/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "gke/dev/+/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "gke/stage/+/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "gke/prod/+/*" {
  capabilities = ["list"]
}