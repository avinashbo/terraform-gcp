provider "google" {
}

resource "random_id" "suffix" {
  byte_length = 4
}

terraform {
  backend "gcs" {
    bucket  = "tfstate-bucket-demo-249805"
  }
}

#resource "google_project" "project" {
#  name                = "tf-demo-${random_id.suffix.hex}"
#  project_id          = "tf-demo-${random_id.suffix.hex}"
#  org_id              = "${var.org}"
#  billing_account     = "${var.billacc}"
#  auto_create_network = false
#}

resource "google_compute_instance" "tf_test_vm" {
  name         = "tf-test-vm"
  project      = "${var.project-id}"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata_startup_script = "echo 'Created by Terraform' > /test.txt"

  network_interface {
    subnetwork = "${google_compute_subnetwork.tf_subnet.self_link}"
  }
}

resource "google_compute_network" "tf_network" {
  name                    = "tf-network"
  project                 = "${var.project-id}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "tf_subnet" {
  name          = "tf-subnet"
  ip_cidr_range = "10.2.0.0/24"
  network       = "${google_compute_network.tf_network.name}"
  project       = "${var.project-id}"
  region        = "${var.region}"
}

resource "google_storage_bucket" "tf_test_bucket" {
  name            = "tf-bucket-1-${random_id.suffix.hex}"
  location        = "${var.region}"
  storage_class   = "REGIONAL"
  project         = "${var.project-id}"
}

resource "google_storage_bucket" "tf_test_bucket_2" {
  name            = "tf-bucket-2-${random_id.suffix.hex}"
  location        = "${var.region}"
  storage_class   = "REGIONAL"
  project         = "${var.project-id}"
}
