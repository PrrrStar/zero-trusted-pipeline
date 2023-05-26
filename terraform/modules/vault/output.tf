output "primary_address" {
  value = google_compute_instance.vault_primary_server.network_interface[0].network_ip
}

output "secondary_address" {
  value = google_compute_instance.vault_secondary_server[0].network_interface[0].network_ip
}