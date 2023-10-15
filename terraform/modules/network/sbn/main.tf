resource "google_compute_subnetwork" "main" {
  name          = var.name
  project       = var.project
  ip_cidr_range = var.subnet_ip_range
  network       = var.vpc_self_link
  region        = var.region

  private_ip_google_access = true

  secondary_ip_range {
    ip_cidr_range = var.subnet_secondary_ip_pod_range
    range_name    = "${var.name}-pod-range"
  }

  secondary_ip_range {
    ip_cidr_range = var.subnet_secondary_ip_svc_range
    range_name    = "${var.name}-svc-range"
  }
}