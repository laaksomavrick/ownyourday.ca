output "cloudfront_endpoint" {
  value = aws_cloudfront_distribution.asset_cache.domain_name
}
