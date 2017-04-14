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
        key_file            = "${file("~/.ssh/id_rsa")}"
        timeout             = "2m"
    }

    provisioner "remote-exec" {
        inline = ["${data.template_file.drone_setup.rendered}"]
    }
}
