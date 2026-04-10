variable "project_id" {
  description = "GCP project ID where resources will be created."
  type        = string
}

variable "machine_type" {
  description = "Compute Engine machine type."
  type        = string
  default     = "n1-standard-8"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB."
  type        = number
  default     = 100
}

variable "ssh_public_key" {
  description = "SSH public key for the root user."
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR range allowed to reach SSH."
  type        = string
  default     = "0.0.0.0/0"
}
