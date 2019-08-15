provider "google" {
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "google_project" "project" {
  name                = "tf-demo-${random_id.suffix.hex}"
  project_id          = "tf-demo-${random_id.suffix.hex}"
  org_id              = "${var.org}"
  billing_account     = "${var.billing_account}"
  auto_create_network = false
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
