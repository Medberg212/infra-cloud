data "aws_route53_zone" "dns" {
  name = "training.akiros.it"
}

resource "aws_route53_record" "nextcloud" {
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = "nextcloud53-${local.user}"
  type    = "A"
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

output "application_fqdn" {
  value       = aws_route53_record.nextcloud.fqdn
  description = "FQDN"
}