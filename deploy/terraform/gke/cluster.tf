resource "google_container_cluster" "torrentscraper-cluster" {
  name       = "torrentscraper-tf-${var.environment}"
  location   = "${var.location}"
  network    = "${google_compute_network.torrentscraper-network.self_link}"
  subnetwork = "${google_compute_subnetwork.torrentscraper-subnet.self_link}"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  resource_labels = {
    product    = "${var.product}"
    component  = "frontend_backend"
    env        = "${var.environment}"
    owner      = "${var.owner}"
    maintainer = "${var.maintainer}"
    state      = "in_use"
  }
}
