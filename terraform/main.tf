resource "cloudflare_dns_record" "wildcard" {
  for_each = toset(var.server_hosts)

  zone_id = var.cloudflare_zone_id
  type    = "A"
  name    = var.server_subdomain
  content = each.value
  ttl     = 1     # automatic
  proxied = false # must be disabled for ACME HTTP-01 challenges
  comment = "Managed by Terraform"
}
