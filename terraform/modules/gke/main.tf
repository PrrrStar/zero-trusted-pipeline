data "google_compute_network" "main" {
  name    = var.vpc_name
  project = var.project
}

data "google_compute_subnetwork" "main" {
  name    = var.subnet_name
  project = var.project
  region  = var.subnet_region
}

resource "google_container_cluster" "main" {
  name               = var.name
  location           = var.zone
  project            = var.project
  min_master_version = var.master_version

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = data.google_compute_network.main.self_link
  subnetwork = data.google_compute_subnetwork.main.self_link

  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = data.google_compute_subnetwork.main.secondary_ip_range[0].range_name
    services_secondary_range_name = data.google_compute_subnetwork.main.secondary_ip_range[1].range_name
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = false
  }

  # metadata
  resource_labels = {
    project    = var.project
    domain     = var.domain
    env        = var.env
    identifier = var.identifier
    location   = var.subnet_region
    made_by    = "terraform"
  }
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  release_channel {
    channel = "UNSPECIFIED"
  }
}

resource "google_container_node_pool" "main" {
  for_each   = { for np in var.nodepool : np["name"] => np }
  name       = each.value["name"]
  cluster    = google_container_cluster.main.name
  location   = var.zone
  node_count = each.value["size"]
  project    = var.project
  version    = var.master_version

  node_locations = [
    var.zone
  ]

  node_config {
    tags = ["k8s-cluster"]

    preemptible  = false
    machine_type = each.value["machine_type"]
    image_type   = "cos_containerd"

    metadata = {
      disable-legacy-endpoints = "true"
      env                      = var.env
    }

    spot         = each.value["spot"]
    disk_type    = "pd-balanced"
    disk_size_gb = "20"

    labels = {
      app      = each.value["name"]
      project  = var.project
      domain   = var.domain
      env      = var.env
      type     = each.value["machine_type"]
      version  = var.master_version
      location = var.zone
      made_by  = "terraform"
    }
  }
  management {
    auto_repair  = each.value["auto_repair"]
    auto_upgrade = each.value["auto_upgrade"]
  }
  upgrade_settings {
    strategy        = "BLUE_GREEN"
    max_surge       = 0
    max_unavailable = 0
  }
}
