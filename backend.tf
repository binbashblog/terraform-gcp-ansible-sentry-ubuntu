terraform {
  backend "gcs"{
    bucket      = "<CHANGEME>"
    prefix      = "/sentry"
    credentials = "terraform.json"
  }
}

