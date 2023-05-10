resource "google_compute_firewall" "vault_ui_api_server" {
  name    = "vault-allow-ui-api-server-${var.suffix}"
  network = var.network
  allow {
    protocol = "tcp"
    ports    = ["8200", "8201"]
  }

  target_tags   = ["${var.tag}-${var.suffix}"]
  source_ranges = [var.source_ip_range]
}