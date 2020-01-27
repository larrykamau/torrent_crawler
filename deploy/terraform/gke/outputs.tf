output "ip-address" {
  value = "${google_compute_address.torrentscraper-static-address.address}"
  sensitive   = true
}

output "cluster-name" {
  value = "${google_container_cluster.torrentscraper-cluster.name}"
}

output "cluster-zone" {
  value = "${google_container_cluster.torrentscraper-cluster.zone}"
}

output "gcp-project-id" {
  value = "${google_container_cluster.torrentscraper-cluster.project}"
}

output "database-user-name" {
  value = "${google_sql_user.torrentscraper-database-user.name}"
}

output "database-user-password" {
  value = "${google_sql_user.torrentscraper-database-user.password}"
  sensitive   = true
}
