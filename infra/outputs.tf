output "instance_name" {
  description = "Name of the compute instance."
  value       = google_compute_instance.cavallo.name
}

output "instance_zone" {
  description = "Zone where the instance is running."
  value       = google_compute_instance.cavallo.zone
}

output "external_ip" {
  description = "Ephemeral public IP of the instance."
  value       = google_compute_instance.cavallo.network_interface[0].access_config[0].nat_ip
}

output "internal_ip" {
  description = "Internal (VPC) IP of the instance."
  value       = google_compute_instance.cavallo.network_interface[0].network_ip
}

output "ssh_command" {
  description = "Ready-to-use SSH command for the root user."
  value       = "ssh root@${google_compute_instance.cavallo.network_interface[0].access_config[0].nat_ip}"
  depends_on  = [google_compute_instance.cavallo]
}
