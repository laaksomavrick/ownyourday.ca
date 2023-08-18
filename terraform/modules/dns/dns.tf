# TODO: alias to load balancer

resource "aws_route53_zone" "main" {
  name = "ownyourday.ca" # TODO: import into terraform via COMMON
}

resource "aws_route53_record" "root-a" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  #  alias {
  #    name                   = aws_cloudfront_distribution.root_s3_distribution.domain_name
  #    zone_id                = aws_cloudfront_distribution.root_s3_distribution.hosted_zone_id
  #    evaluate_target_health = false
  #  }
}

resource "aws_route53_record" "www-a" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  #  alias {
  #    name                   = aws_cloudfront_distribution.www_s3_distribution.domain_name
  #    zone_id                = aws_cloudfront_distribution.www_s3_distribution.hosted_zone_id
  #    evaluate_target_health = false
  #  }
}

resource "aws_route53_record" "main" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate" "ssl_certificate" {
  provider                  = aws.acm_provider
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert_validation" {
  provider                = aws.acm_provider
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.main : record.fqdn]
}

