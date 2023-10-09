output "apigw_dns_name" {
  value = aws_apigatewayv2_domain_name.app_api_gw_domain.domain_name_configuration[0].target_domain_name
}

output "apigw_zone_id" {
  value = aws_apigatewayv2_domain_name.app_api_gw_domain.domain_name_configuration[0].hosted_zone_id
}
