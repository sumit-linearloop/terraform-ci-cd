terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"  # Use the latest version within the 3.x range
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"  # Example: Use the latest version within the 2.x range
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

