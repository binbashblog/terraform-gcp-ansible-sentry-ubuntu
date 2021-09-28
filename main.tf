terraform {
  required_version = "> 1.0"
}

// define variables

variable "sentry_name" {
  type = string
}

variable "sentry_hostname" {
  type = string
}

variable "sentry_machine_type" {
  type = string
}

variable "sentry_image" {
  type = string
}

variable "ansible_playbook_name" {
  type = string
}

variable "network_interface" {
  type = string
}

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

variable "ssh_pri_key_path" {
  type = string
}
