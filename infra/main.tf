terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "local" {}
}

provider "google" {
  project = var.project_id
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

# ── Network ────────────────────────────────────────────────────────────────────

resource "google_compute_network" "cavallo" {
  name                    = "cavallo-network"
  auto_create_subnetworks = true
}

# ── Firewall ───────────────────────────────────────────────────────────────────

resource "google_compute_firewall" "allow_ssh" {
  name    = "cavallo-allow-ssh"
  network = google_compute_network.cavallo.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.allowed_ssh_cidr]
  target_tags   = ["cavallo-ssh"]
}

# ── VM ─────────────────────────────────────────────────────────────────────────

resource "google_compute_instance" "cavallo" {
  name         = "cavallo-inference"
  machine_type = var.machine_type
  zone         = "europe-west1-b"

  tags = ["cavallo-ssh"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = var.disk_size_gb
      type  = "pd-ssd"
    }
  }

  scheduling {
    on_host_maintenance = "MIGRATE"
    automatic_restart   = true
  }

  network_interface {
    network = google_compute_network.cavallo.name
    access_config {}
  }

  metadata = {
    ssh-keys = "root:${var.ssh_public_key}"
  }

  labels = {
    purpose = "llm-inference"
    managed = "opentofu"
  }
}
