variable "project" {
  type        = string
  description = "Project 이름"
}

variable "name" {
  type        = string
  description = "Cluster 이름"
}

variable "env" {
  type        = string
  description = "Project environment code"
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

variable "identifier" {
  type        = string
  description = "GKE 클러스터 ID (형식: YYMMDD)"
}

variable "zone" {
  type        = string
  description = "GKE 클러스터 zone"
}

variable "subnet_region" {
  type        = string
  description = "GKE 클러스터 Subnet region"
}

variable "master_version" {
  type        = string
  description = "GKE 클러스터 master version"
}

variable "nodepool" {
  type = list(any)
}
