module "gke" {
  for_each = { for gke in local.gke : gke["cluster_name"] => gke }

  source         = "./modules/gke"
  domain         = local.domain
  env            = local.env
  project        = local.project
  identifier     = local.identifier
  vpc_name       = data.google_compute_network.main.name
  subnet_name    = data.google_compute_subnetwork.public.name
  subnet_region  = data.google_compute_subnetwork.public.region
  zone           = "${data.google_compute_subnetwork.public.region}-a"
  master_version = each.value["cluster_version"]
  node_config    = each.value["nodepool"]
}