terraform {
  required_version = ">= 1.0.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"  # Updated to the 4.x range for compatibility with newer Terraform versions
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"  # Keep this as is, assuming it's compatible with your setup
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# Configure the Cloudflare Provider
provider "cloudflare" {
  # Add any necessary Cloudflare provider configurations here
  # For example:
  # api_token = var.cloudflare_api_token
}
