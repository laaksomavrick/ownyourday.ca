resource "aws_service_discovery_private_dns_namespace" "cloudmap_namespace" {
  name = "${var.app_name}-cloudmap-namespace"
  vpc  = aws_vpc.app_vpc.id
}

resource "aws_service_discovery_service" "cloudmap_service" {
  name = "${var.app_name}-cloudmap-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.cloudmap_namespace.id

    dns_records {
      ttl  = 60
      type = "SRV"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
