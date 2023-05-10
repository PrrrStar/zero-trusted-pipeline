# Provider Variables
project_id = "prj-d-devops"
region     = "asia-northeast3"

# Vault Module Variables
machine_type  = "n1-standard-1"
image_project = "prj-d-devops"
image_family  = "vault"
tag           = "vault"
zone          = "asia-northeast3-a"
num_instances = 2

# This will open up instance for entire internet. USE WITH CAUTION
network         = "default"
source_ip_range = "0.0.0.0/0"

# Vault Config
vault_storage_ha_enabled = "true"
vault_ui_enabled         = "true"