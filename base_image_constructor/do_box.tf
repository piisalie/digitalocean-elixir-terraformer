variable "token" {}
variable "ssh_keys" { type = "list" }
variable "sudo_pw" {}
variable "username" {}

provider "digitalocean" {
    token = "${var.token}"
}

resource "digitalocean_droplet" "web" {
    image = "ubuntu-16-04-x64"
    name = "base-build-image"
    region = "nyc3"
    size = "512mb"
    ssh_keys = ["${var.ssh_keys}"]


  provisioner "remote-exec" {
    inline = [
      "useradd -m ${var.username} --shell /bin/bash",
      "echo ${var.username}:${var.sudo_pw} | chpasswd",
      "gpasswd -a ${var.username} sudo",
      "mkdir -p /home/${var.username}/.ssh",
      "cp /root/.ssh/authorized_keys /home/${var.username}/.ssh/",
      "chown app:app /home/${var.username}/.ssh/authorized_keys",
      ]
  }

  provisioner "file" {
      source = "./config/update-env.sh"
      destination = "/tmp/update-env.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/update-env.sh",
      "/tmp/update-env.sh"
    ]
  }

  provisioner "file" {
      source = "./config/sshd_config"
      destination = "/etc/ssh/sshd_config"
  }

  provisioner "remote-exec" {
    inline = [
      "service sshd restart",
    ]
  }

  provisioner "file" {
    source = "./config/bootstrap-elixir.sh"
    destination = "/tmp/bootstrap-elixir.sh"
    connection {
      type = "ssh"
      user = "${var.username}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap-elixir.sh",
      "/tmp/bootstrap-elixir.sh",
      "mkdir ~/app"
      ]
    connection {
      type = "ssh"
      user = "${var.username}"
    }
  }

}
