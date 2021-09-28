resource "google_compute_instance" "terraform-gcp-sentry-ubuntu" {
    name		= "${var.sentry_name}"
    hostname		= "${var.sentry_hostname}"
    machine_type	= "${var.sentry_machine_type}"
    zone		= "${var.zone}"
    tags                = ["web"]

    boot_disk {
        initialize_params {
            image = "${var.sentry_image}"
        }
    }
  

    network_interface {
        network = "${var.network_interface}"
        access_config {
            nat_ip = "${google_compute_address.static.address}"
      }
    }
    
    service_account {
        scopes = ["storage-rw"]
    }

    allow_stopping_for_update = false

// point to the ssh keys var defined in tfvars, this pubkey will be deployed to the instance so ansible will work

    metadata = {
        ssh-keys = "${var.ssh_username}:${file(var.ssh_pub_key_path)}"
    }
    
   
    provisioner "remote-exec" {
    inline = ["sudo apt-get update; sudo apt-get -y install python3"]

    connection {
      type        	= "ssh"
      host		= self.network_interface[0].access_config[0].nat_ip
      user        	= "${var.ssh_username}"
      private_key 	= "${file(var.ssh_pri_key_path)}"
    }
    }

    provisioner "local-exec" {
      command = "ansible-playbook -u ${var.ssh_username} -i '${self.network_interface.0.access_config.0.nat_ip},' --private-key ${var.ssh_pri_key_path} ${var.ansible_playbook_name}"
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
   ports    = ["443", "22"]
 }

// change source range to your IP to restrict access
 source_ranges = ["0.0.0.0/0"]
 source_tags = ["web"]

}
