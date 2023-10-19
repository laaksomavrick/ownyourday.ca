resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "root-a" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300
  records = [var.reverse_proxy_public_ip]
}

resource "aws_route53_record" "www-a" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_route53_record.root-a.fqdn
    zone_id                = aws_route53_record.root-a.zone_id
    evaluate_target_health = true
  }

}
