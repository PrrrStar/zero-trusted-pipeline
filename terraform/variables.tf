# Vault Instance Variables

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "num_instances" {
  type    = number
  default = 1
}

variable "zone" {
  type = string
}

variable "image_project" {
  type = string
}

variable "image_family" {
  type = string
}

variable "network" {
  type = string
}

variable "tag" {
  type = string
}

variable "source_ip_range" {
  type = string
}


# Vault Config Variables
variable "vault_storage_ha_enabled" {
  type = string
}

variable "vault_ui_enabled" {
  type = string
}