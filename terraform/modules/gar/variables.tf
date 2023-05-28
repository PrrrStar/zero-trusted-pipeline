variable "iam" {
  description = "IAM bindings in {ROLE => [MEMBERS]} format."
  type        = map(list(string))
  default     = {}
}

variable "location" {
  description = "Registry location. Use `gcloud beta artifacts locations list' to get valid values"
  type        = string
  default     = ""
}

variable "project" {
  description = "Registry project id."
  type        = string
}

variable "labels" {
  description = "Labels to be attached to the registry."
  type        = map(string)
  default     = {}
}

variable "format" {
  description = "Repository format. One of DOCKER or UNSPECIFIED"
  type        = string
  default     = "DOCKER"
}

variable "description" {
  description = "An optional description for the repository"
  type        = string
  default     = "Terraform-managed registry"
}

variable "id" {
  description = "Repository id"
  type        = string
}

variable "iam_additive" {
  description = "IAM additive bindings in {ROLE => [MEMBERS]} format.	"
  type        = map(list(string))
  default     = {}
}