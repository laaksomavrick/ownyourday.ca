data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/init.cfg", {})
  }
}


# Start an AWS instance with the cloud-init config as user data
resource "aws_instance" "reverse_proxy" {
  count                       = 1 # Toggle off to delete
  ami                         = "ami-0ea18256de20ecdfc" # UBUNTU
  instance_type               = "t2.nano"
  user_data_base64            = data.cloudinit_config.config.rendered
  user_data_replace_on_change = true
  subnet_id                   = var.reverse_proxy_subnet_id
  associate_public_ip_address = true
  key_name                    = var.key_name

  vpc_security_group_ids = var.reverse_proxy_security_group_ids

  tags = {
    Name = "${var.app_name}-load-balancer"
  }

}
