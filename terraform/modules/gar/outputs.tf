output "id" {
  description = "Repository id"
  value       = google_artifact_registry_repository.registry.id
}

output "name" {
  description = "Repository name"
  value       = google_artifact_registry_repository.registry.name
}