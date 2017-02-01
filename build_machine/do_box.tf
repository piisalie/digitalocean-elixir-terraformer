variable "token" {}
variable "ssh_keys" { type = "list" }
variable "appname" {}
variable "size" {}
variable "imageid" {}
variable "appdir" {}
variable "username" {}

provider "digitalocean" {
    token = "${var.token}"
}

resource "digitalocean_droplet" "web" {
    image = "${var.imageid}"
    name = "${var.appname}"
    region = "nyc3"
    size = "${var.size}"
    ssh_keys = ["${var.ssh_keys}"]

  provisioner "file" {
    source = "${var.appdir}"
    destination = "~/app"
    connection {
      type = "ssh"
      user = "${var.username}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/app/bootstrap.sh",
      "~/app/bootstrap.sh",
      ]
    connection {
      type = "ssh"
      user = "${var.username}"
    }
  }

}