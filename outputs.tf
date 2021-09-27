  output "ip" {
    value = "${google_compute_instance.terraform-gcp-sentry-ubuntu.network_interface.0.access_config.0.nat_ip}"
  }
