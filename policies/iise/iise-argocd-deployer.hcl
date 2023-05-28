path "kubernetes/+/dev/*" {
  capabilities = ["read", "list"]
}

path "kubernetes/+/stage/*" {
  capabilities = ["read", "list"]
}

path "kubernetes/+/prod/*" {
  capabilities = ["read", "list"]
}