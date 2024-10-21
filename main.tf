resource "digitalocean_ssh_key" "default" {
  name       = "terra-key"
  public_key = file(var.ssh_public_key_path)
}

resource "digitalocean_droplet" "web_server" {
  image    = ubuntu-24-04-x64
  name     = sumit
  region   = blr1
  size     = s-1vcpu-1gb
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.ssh_private_key_path)
    host        = self.ipv4_address
  }

  provisioner "file" {
    source      = "${path.module}/initial_setup.sh"
    destination = "/tmp/initial_setup.sh"
  }

  provisioner "file" {
    source      = "${path.module}/app_setup.sh"
    destination = "/tmp/app_setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/initial_setup.sh",
      "chmod +x /tmp/app_setup.sh",
      "SSH_PRIVATE_KEY='${file(var.ssh_private_key_path)}' NODE_VERSION='${var.node_version}' AWS_ACCESS_KEY='${var.aws_access_key}' AWS_SECRET_KEY='${var.aws_secret_key}' AWS_REGION='${var.aws_region}' bash /tmp/initial_setup.sh"
    ]
  }
}

resource "null_resource" "app_management" {
  depends_on = [digitalocean_droplet.web_server]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.ssh_private_key_path)
    host        = digitalocean_droplet.web_server.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/app_setup.sh",
      "DRAGONFLY_REPO='${var.dragonfly_repo}' FIREFLY_REPO='${var.firefly_repo}' FIREFLY_PORT='${var.firefly_port}' DRAGONFLY_PORT='${var.dragonfly_port}' FIREFLY_DOMAIN='${var.firefly_domain}' DRAGONFLY_DOMAIN='${var.dragonfly_domain}' DRAGONFLY_SECRET='${var.dragonfly_secret}' FIREFLY_SECRET='${var.firefly_secret}' DRAGONFLY_BRANCH='${var.dragonfly_branch}' FIREFLY_BRANCH='${var.firefly_branch}' bash -l /tmp/app_setup.sh ${var.app_action}"
    ]
  }

  triggers = {
    app_action = var.app_action
  }
}