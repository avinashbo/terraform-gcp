provider "google" {
  project     = "terraform-demo-249805"
}

resource "google_container_cluster" "my_cluster" {
  name     = "tf-gke-cluster"
  location = "${var.region}"
  remove_default_node_pool = true
  initial_node_count = 1
}

resource "google_container_node_pool" "my_node_pool" {
  name       = "my-np"
  location   = "${var.region}"
  cluster    = "${google_container_cluster.my_cluster.name}"
  node_count = 1

  node_config {
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
