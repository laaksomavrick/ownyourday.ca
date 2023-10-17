# Install Docker
# Download docker image
# Run docker image
# Expose on port

# Configure aws logs
# Configure newrelic

data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/init.cfg", {
      image          = "${var.app_image_repo}:${var.app_image_version}"
      host_port      = 80
      container_port = var.container_port
    })
  }
}


# Start an AWS instance with the cloud-init config as user data
resource "aws_instance" "backend" {
  count                       = 0 # Toggle off to delete
  ami                         = "ami-0f17d6a8a3d746af6"
  instance_type               = "t2.nano"
  user_data_base64            = data.cloudinit_config.config.rendered
  subnet_id                   = var.backend_subnet_id
  associate_public_ip_address = true
  key_name                    = var.key_name

  vpc_security_group_ids = var.backend_security_group_ids

  iam_instance_profile = aws_iam_instance_profile.instance.name

  tags = {
    Name = "${var.app_name}-backend"
  }

}
