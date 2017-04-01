# Configure DO Provider
provider "digitalocean" {
    token                   = "${var.DO_TOKEN}"
}

data "template_file" "drone_setup" {
  template = "${file("${path.module}/scripts/setup_drone.sh.tpl")}"
  vars {
    DRONE_GITHUB_CLIENT     = "${var.DRONE_GITHUB_CLIENT}"
    DRONE_GITHUB_SECRET     = "${var.DRONE_GITHUB_SECRET}"
    DRONE_SECRET            = "${var.DRONE_SECRET}"
  }
}

# Create Droplet with Docker
resource "digitalocean_droplet" "ci" {
    image                   = "docker"
    name                    = "${var.droplet_name}"
    region                  = "${var.droplet_region}"
    size                    = "${var.droplet_size}mb"

    ipv6                    = true
    private_networking      = true

    ssh_keys                = [
        "${digitalocean_ssh_key.ci.fingerprint}"
    ]

    connection {
        user                = "root"
        type                = "ssh"
        key_file            = "${file(var.private_key)}"
        timeout             = "2m"
    }

    provisioner "remote-exec" {
        inline = ["${data.template_file.drone_setup.rendered}"]
    }
}

resource "digitalocean_floating_ip" "ci" {
    droplet_id              = "${digitalocean_droplet.ci.id}"
    region                  = "${digitalocean_droplet.ci.region}"
}

resource "digitalocean_ssh_key" "ci" {
    name                    = "Drone"
    public_key              = "${file(var.public_key)}"
}
