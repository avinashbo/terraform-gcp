variable "instance_name" {}
variable "instance_zone" {}
variable "instance_type" {
  default = "n1-standard-1"
  }
variable "instance_subnetwork" {}

resource "google_compute_instance" "vm_instance" {
  project      = "tf-demo-6611774b"
  name         = "${var.instance_name}"
  zone         = "${var.instance_zone}"
  machine_type = "${var.instance_type}"
  boot_disk {
    initialize_params {
      image = "coreos-cloud/coreos-stable"
      }
  }
  network_interface {
    subnetwork = "${var.instance_subnetwork}"
  }
}
