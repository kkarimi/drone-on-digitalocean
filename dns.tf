resource "digitalocean_floating_ip" "ci" {
    droplet_id              = "${digitalocean_droplet.ci.id}"
    region                  = "${digitalocean_droplet.ci.region}"
}
