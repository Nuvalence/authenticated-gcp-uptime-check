terraform {
  backend "gcs" {
    bucket = "authenticated-gcp-uptime-check"
    prefix = "terraform"
  }
}
