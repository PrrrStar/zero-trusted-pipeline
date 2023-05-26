variable "project" {
  type        = string
  description = "Project 이름"
  validation {
    condition = contains([
      "prj-d-devops",
    ], var.project)
    error_message = "Project 이름이 올바르지 않습니다."
  }
}

variable "region" {
  type        = string
  description = "Network 리전"
}

variable "env" {
  type        = string
  description = "Project environment code"
  validation {
    condition = contains([
      "d",
      "st",
      "sm",
      "pt",
      "pm"
    ], var.env)
    error_message = "Environment 코드가 올바르지 않습니다."
  }
}

variable "domain" {
  type        = string
  description = "Project domain"
}

variable "name" {
  type        = string
  description = "Network name"
}

variable "vpc_self_link" {
  type        = string
  description = "VPC Self link"
}

variable "subnet_ip_range" {
  type        = string
  description = "main 서브넷 IP CIDR"
}

variable "subnet_secondary_ip_pod_range" {
  type        = string
  description = "main 서브넷 별칭 IP CIDR - Pod IP 범위"
}

variable "subnet_secondary_ip_svc_range" {
  type        = string
  description = "main 서브넷 별칭 IP CIDR - Service IP 범위"
}