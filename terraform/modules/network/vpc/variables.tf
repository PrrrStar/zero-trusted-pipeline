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
  description = "Main VPC name which located in Kubernetes, Bastion host"
}