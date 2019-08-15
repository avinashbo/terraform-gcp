provider "google" {
  project     = "terraform-demo-249805"
}

resource "google_compute_instance" "tf_test" {
  name         = "tf-test-vm"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"

  disk {
    image = "debian-cloud/debian-9"
  }
  
  metadata_startup_script = "echo hi > /test_terraform.txt"

  network_interface {
    subnetwork = "${google_compute_subnetwork.tf-subnet.name}"
  }
}

resource "google_compute_network" "tf_network" {
  name                    = "tf-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "tf_subnet" {
  name          = "tf-subnet"
  ip_cidr_range = "10.2.0.0/24"
  network       = "${google_compute_network.tf_network.self_link}"
  region        = "${var.region}"
}
