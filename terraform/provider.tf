provider "google" {
  region      = local.region
  project     = local.project
  credentials = file("secrets.prj-d-devops-402107.json")
}

variable "gcp_service_list" {
  description = "The list of apis necessary for the project"
  type        = list(string)
  default = [
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudkms.googleapis.com",
    "iam.googleapis.com",
    "storage-api.googleapis.com",
    "storage.googleapis.com",
    "servicemanagement.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "artifactregistry.googleapis.com"
  ]
}

resource "google_project_service" "gcp_services" {
  for_each = toset(var.gcp_service_list)
  project  = var.project
  service  = each.key
}