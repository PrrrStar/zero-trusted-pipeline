resource "google_compute_firewall" "vault_ui_api_server" {
  name    = "vault-allow-ui-api-server-${var.suffix}"
  network = var.vpc_name
  allow {
    protocol = "tcp"
    ports    = ["8200", "8201", "22"]
  }

  target_tags   = ["${var.tag}-${var.suffix}"]
  source_ranges = [var.source_ip_range]
}