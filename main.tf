terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }

  backend "gcs" {
    bucket  = "calimanfilho-terraform"
    prefix  = "terraform/state"
  }
}

provider "google" {
  project = "${var.project_id}"
  region  = "us-east1"
  zone    = "us-east1-b"
}

resource "google_compute_network" "vpc_network" {
  name = "${var.network_name}"
}

resource "google_compute_instance" "vm_instance" {
  name          = "cloudbuild-terraform"
  machine_type  = "f1-micro"
  tags          = ["prod"]

  labels = {
    centro_custo = "${var.label_name}"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}