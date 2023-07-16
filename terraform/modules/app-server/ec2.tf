data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-*-arm64"]
  }

  owners = ["amazon"]
}


resource "aws_cloudwatch_log_group" "instance" {
  name = "${var.app_name}-log-group"
}

resource "aws_iam_role" "instance" {
  name = "${var.app_name}-instance-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "instance_policy" {
  statement {
    sid = "CloudwatchPutMetricData"

    actions = [
      "cloudwatch:PutMetricData",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "InstanceLogging"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = [
      aws_cloudwatch_log_group.instance.arn,
    ]
  }
}

resource "aws_iam_policy" "instance_policy" {
  name   = "${var.app_name}-ecs-instance"
  path   = "/"
  policy = data.aws_iam_policy_document.instance_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_policy" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "instance_policy" {
  role       = aws_iam_role.instance.name
  policy_arn = aws_iam_policy.instance_policy.arn
}

resource "aws_iam_instance_profile" "instance" {
  name = "${var.app_name}-instance-profile"
  role = aws_iam_role.instance.name
}
resource "aws_autoscaling_group" "asg" {
  name = "${var.app_name}-asg"

  vpc_zone_identifier = var.public_subnet_ids
  max_size            = 2
  min_size            = 1
  desired_capacity    = 1

  health_check_grace_period = 300
  health_check_type         = "EC2"

  launch_template {
    id      = aws_launch_template.instance.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_template" "instance" {
  name_prefix            = "${var.app_name}-lt"
  image_id               = data.aws_ami.ecs.id
  instance_type          = "t4g.nano"
  user_data              = base64encode(templatefile("${path.module}/user_data.sh", { log_group = aws_cloudwatch_log_group.instance.name, ecs_cluster = "TODO" }))
  vpc_security_group_ids = var.public_security_group_ids
  key_name               = aws_key_pair.deployer.key_name

  iam_instance_profile {
    arn = aws_iam_instance_profile.instance.arn
  }

  lifecycle {
    create_before_destroy = true
  }
}
