resource "google_compute_instance" "terraform-gcp-sentry-ubuntu" {
    name		= "sentry-vm"
    machine_type	= "n1-standard-2"
    zone		= "europe-west2-c"

    boot_disk {
        initialize_params {
            image = "ubuntu-os-cloud/ubuntu-2004-lts"
        }
    }
  

    network_interface {
        network = "default"
        access_config {
            nat_ip = "${google_compute_address.static.address}"
      }
    }

// point to the ssh keys var defined in tfvars, this pubkey will be deployed to the instance so ansible will work

    metadata = {
        ssh-keys = "${var.ssh_username}:${file(var.ssh_pub_key_path)}"
    }
    
   
    provisioner "remote-exec" {
    inline = ["sudo apt-get update; sudo apt-get -y install python"]

    connection {
      type        = "ssh"
      user        = "${var.ssh_username}"
      private_key = "${var.ssh_pri_key_path}"
    }
    }

    provisioner "local-exec" {
      command = "ansible-playbook -u ubuntu -i '${self.public_ip},' --private-key ${var.ssh_pri_key_path} sentry-playbook.yml"
    }


}


// Define networking

resource "google_compute_address" "static" {
  name = "ipv4-address"
}

resource "google_compute_firewall" "default" {
 name    = "sentry-firewall"
 network = "default"

 allow {
   protocol = "icmp"
 }

 allow {
   protocol = "tcp"
   ports    = ["443"]
 }

// change source range to your IP to restrict access
 source_ranges = ["0.0.0.0/0"]
 source_tags = ["web"]

}
