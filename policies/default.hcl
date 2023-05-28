# Read namespaces
path "sys/namespaces/*" {
  capabilities = ["read", "list"]
}

# List policies
path "sys/policies/acl/*" {
  capabilities = ["list"]
}

# List policies
path "sys/policies/acl" {
  capabilities = ["list"]
}

# Read Secrets Engines (Cannot Enable / Disable)
path "sys/mounts/*" {
  capabilities = ["read", "list"]
}

# Read available secrets engines
path "sys/mounts" {
  capabilities = [ "read" ]
}

# View entities and groups
path "identity/*" {
  capabilities = ["read", "list"]
}

# Allow tokens to look up their own properties
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

# Allow tokens to renew themselves
path "auth/token/renew-self" {
  capabilities = ["update"]
}

# Allow tokens to revoke themselves
path "auth/token/revoke-self" {
  capabilities = ["update"]
}

# Allow a token to look up its own capabilities on a path
path "sys/capabilities-self" {
  capabilities = ["update"]
}