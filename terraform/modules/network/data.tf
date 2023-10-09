data "aws_availability_zones" "vpc_link_enabled" {
  filter {
    name   = "zone-id"
    values = ["cac1-az1", "cac1-az2"]
  }
}
