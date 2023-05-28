locals {
  iam_additive_list = flatten([
    for role, members in var.iam_additive :
    [for member in members : { role : role, member : member }]
  ])

  iam_additive_map = {
    for v in local.iam_additive_list : "${v.role}/${v.member}" => v
  }

}

resource "google_artifact_registry_repository" "registry" {
  provider      = google-beta
  project       = var.project
  location      = var.location
  description   = var.description
  format        = var.format
  labels        = var.labels
  repository_id = var.id
}

resource "google_artifact_registry_repository_iam_binding" "bindings" {
  provider   = google-beta
  for_each   = var.iam
  project    = var.project
  location   = google_artifact_registry_repository.registry.location
  repository = google_artifact_registry_repository.registry.name
  role       = each.key
  members    = each.value
}

resource "google_artifact_registry_repository_iam_member" "bindings_member" {
  provider   = google-beta
  for_each   = local.iam_additive_map
  project    = var.project
  location   = google_artifact_registry_repository.registry.location
  repository = google_artifact_registry_repository.registry.name
  role       = each.value.role
  member     = each.value.member
}