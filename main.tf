terraform {
  required_version = "~> 0.12"
}

// define provider variables

variable "project_name" {
  type = string
}

variable "gcp_credentials_path" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "ssh_pub_key_path" {
  type = string
}
