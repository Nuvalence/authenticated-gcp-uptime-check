# import the secrets
data "google_secret_manager_secret_version" "client_id" {
  project = var.project_id
  secret  = "spotify-client-id"
  version = "1"
}

data "google_secret_manager_secret_version" "client_secret" {
  project = var.project_id
  secret  = "spotify-client-secret"
  version = "1"
}

data "external" "curl" {
  program = [
    "sh",
    "get-access-token.sh",
    data.google_secret_manager_secret_version.client_id.secret_data,
    data.google_secret_manager_secret_version.client_secret.secret_data
  ]
}

resource "google_monitoring_uptime_check_config" "http" {
  display_name = "spotify-uptime-check"
  timeout      = "10s"
  period       = "600s"

  http_check {
    path           = "/v1/browse/categories?limit=5"
    request_method = "GET"
    headers = {
      "authorization" : "Bearer ${data.external.curl.result.token}"
    }
    mask_headers = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = "api.spotify.com"
    }
  }
}
