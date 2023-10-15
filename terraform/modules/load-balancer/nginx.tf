data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  #  # Main cloud-config configuration file.
  # TODO: https://cloudinit.readthedocs.io/en/latest/reference/examples.html
  # Can do everything from this...?
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/init.cfg", {})
  }

  #  part {
  #    content_type = "text/x-shellscript"
  #    content      = templatefile("${path.module}/user_data.sh", {})
  #  }
  #
  #  part {
  #    content_type = "text/x-shellscript"
  #    content      = "ffbaz"
  #  }
}

# Start an AWS instance with the cloud-init config as user data
resource "aws_instance" "nginx" {
  count                       = 1 # Toggle off to delete
  ami                         = "ami-0f17d6a8a3d746af6"
  instance_type               = "t2.nano"
  user_data_base64            = data.cloudinit_config.config.rendered
  subnet_id                   = var.lb_subnet_id
  associate_public_ip_address = true
  key_name                    = var.key_name

  security_groups = var.lb_security_group_ids

  tags = {
    Name = "${var.app_name}-load-balancer"
  }

}
