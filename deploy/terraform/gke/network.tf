resource "google_compute_network" "torrentscraper-network" {
  name                    = "torrentscraper-tf-${var.environment}-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "torrentscraper-subnet" {
  name                     = "torrentscraper-tf-${var.environment}-subnet"
  ip_cidr_range            = "10.0.0.0/18"
  network                  = "${google_compute_network.torrentscraper-network.self_link}"
  private_ip_google_access = "true"
}

resource "google_compute_address" "torrentscraper-static-address" {
  name         = "torrentscraper-tf-${var.environment}-static-address"
  address_type = "EXTERNAL"
}
