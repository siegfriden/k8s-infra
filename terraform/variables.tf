variable "server_hosts" {
  description = "IPv4 addresses of the servers."
  type        = list(string)
}

variable "server_subdomain" {
  description = "Subdomain for the server (e.g. k8s.example.com)."
  type        = string
}

variable "cloudflare_token" {
  description = "Cloudflare API Token."
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID."
  type        = string
}
