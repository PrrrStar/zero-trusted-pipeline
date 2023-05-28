resource "google_artifact_registry_repository" "registry" {
  project       = local.project
  location      = "asia-northeast3"
  repository_id = "devops-infra"
  format        = "docker"
  docker_config {
    immutable_tags = true
  }
}

resource "google_artifact_registry_repository_iam_binding" "bindings" {
  project    = local.project
  location   = google_artifact_registry_repository.registry.location
  repository = google_artifact_registry_repository.registry.name
  role       = "roles/artifactregistry.writer"
  members = [
    "user:ethan@haechi.io"
  ]
}

resource "google_artifact_registry_repository_iam_member" "bindings_member" {
  project    = var.project
  location   = google_artifact_registry_repository.registry.location
  repository = google_artifact_registry_repository.registry.name
  role       = "roles/artifactregistry.writer"
  member     = "user:ethan@haechi.io"
}