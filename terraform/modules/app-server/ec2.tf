data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_autoscaling_group" "asg" {
  name = "${var.app_name}-asg"

  launch_configuration = aws_launch_configuration.instance.name
  vpc_zone_identifier  = var.public_subnet_ids
  max_size             = 2
  min_size             = 1
  desired_capacity     = 1

  health_check_grace_period = 300
  health_check_type         = "EC2"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "instance" {
  name_prefix          = "${var.app_name}-lc"
  image_id             = data.aws_ami.ecs.id
  instance_type        = "t4g.nano"
  iam_instance_profile = "${aws_iam_instance_profile.instance.name}"
  user_data            = "${data.template_file.user_data.rendered}"
  security_groups      = var.public_security_group_ids
  key_name             = "${var.instance_keypair != "" ? var.instance_keypair : element(concat(aws_key_pair.user.*.key_name, list("")), 0)}"

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
  }
}
