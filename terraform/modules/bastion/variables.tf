variable "project" {
  type        = string
  description = "Project 이름"
}

variable "env" {
  type        = string
  description = "Project environment code"
}

variable "identifier" {
  type        = string
  description = "identifier"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "subnet_name" {
  type        = string
  description = "Subnetwork name"
}

variable "domain" {
  type        = string
  description = "Project domain"
}

variable "zone" {
  type        = string
  description = "VM 인스턴스 zone"
}

variable "machine_type" {
  type        = string
  description = "Worker node 스펙 (ex: n2-8cpu-16mem)"
}

variable "boot_disk_size" {
  type        = number
  description = "부팅 디스크 크기"
  default     = 10
}

variable "network_tags" {
  type        = list(string)
  description = "방화벽을 적용할 네트워크 태그"
}

variable "ports" {
  type        = list(string)
  description = "적용할 포트"
}

variable "protocol" {
  type        = string
  description = "프로토콜"
  default     = "tcp"
}

variable "source_ranges" {
  type        = list(string)
  description = "적용할 IP 대역"
}

variable "region" {
  type = string
}

variable "type" {
  type        = string
  description = "IP Address Type. (Default : EXTERNAL"
  default     = "EXTERNAL"
}

variable "vault_server_primary_address" {
  type = string
}

variable "vault_server_secondary_address" {
  type = string
}