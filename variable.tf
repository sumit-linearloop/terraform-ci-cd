variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key"
  type        = string
}

variable "droplet_image" {
  description = "Droplet image to use"
  type        = string
}

variable "droplet_name" {
  description = "Name of the droplet"
  type        = string
}

variable "droplet_region" {
  description = "Region for the droplet"
  type        = string
}

variable "droplet_size" {
  description = "Size of the droplet"
  type        = string
}

variable "node_version" {
  description = "Node.js version to install"
  type        = string
}

variable "dragonfly_repo" {
  description = "GitHub repository URL for Dragonfly"
  type        = string
}

variable "firefly_repo" {
  description = "GitHub repository URL for Firefly"
  type        = string
}

variable "app_action" {
  description = "Action to perform on the app (setup_dragonfly, setup_firefly, destroy_dragonfly, destroy_firefly)"
  type        = string
}

variable "firefly_port" {
  description = "Port for Firefly application"
  type        = number
}

variable "dragonfly_port" {
  description = "Port for Dragonfly application"
  type        = number
}

variable "dragonfly_domain" {
  description = "Dragonfly Domain"
  type        = string  
}

variable "firefly_domain" {
  description = "Firefly Domain"
  type        = string
}

variable "firefly_secret" {
  description = "Secret name for Firefly"
}

variable "dragonfly_secret" {
  description = "Secret name for Dragonfly"
}

variable "firefly_branch" {
  description = "Branch for Firefly"
}

variable "dragonfly_branch" {
  description = "Branch for Dragon"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "github_token" {
  description = "GitHub token for authentication"
  type        = string
}

variable "github_secret" {
  description = "GitHub secret for additional operations"
  type        = string
}


variable "dragonfly_count" {
  description = "Count of Dragonfly instances"
  type        = number
  default     = 1 # Or any appropriate default value
}

variable "firefly_count" {
  description = "Count of Firefly instances"
  type        = number
  default     = 1 # Or any appropriate default value
}
