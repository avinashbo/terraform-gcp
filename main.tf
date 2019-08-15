provider "google" {
  project     = "terraform-demo-249805"
}


resource "google_compute_instance" "tf_test_vm" {
  name         = "tf-test-vm"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata_startup_script = "echo 'Created by Terraform' > /test.txt"

  network_interface {
    subnetwork = "${google_compute_subnetwork.tf_subnet.name}"
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
