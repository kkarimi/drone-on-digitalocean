resource "digitalocean_ssh_key" "ci" {
    name                    = "Drone"
    public_key              = "${file("~/.ssh/id_rsa.pub")}"
}
