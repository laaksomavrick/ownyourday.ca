resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = "${var.app_name}-vpc-link"
  security_group_ids = var.vpc_link_security_group_ids
  subnet_ids         = var.app_subnet_ids
}

resource "aws_apigatewayv2_api" "app_api_gw" {
  name          = "${var.app_name}-api-gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "app_api_gw_integration" {
  api_id             = aws_apigatewayv2_api.app_api_gw.id
  connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id
  connection_type    = "VPC_LINK"
  integration_method = "ANY"
  integration_type   = "HTTP_PROXY"
  integration_uri    = var.cloudmap_service_arn
}

resource "aws_apigatewayv2_stage" "app_api_gw_stage" {
  api_id      = aws_apigatewayv2_api.app_api_gw.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_route" "app_api_gw_stage_route" {
  api_id    = aws_apigatewayv2_api.app_api_gw.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.app_api_gw_integration.id}"
}

resource "aws_apigatewayv2_domain_name" "app_api_gw_domain" {
  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.ssl_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "app_api_gw_mapping" {
  api_id      = aws_apigatewayv2_api.app_api_gw.id
  domain_name = aws_apigatewayv2_domain_name.app_api_gw_domain.id
  stage       = aws_apigatewayv2_stage.app_api_gw_stage.id
}
